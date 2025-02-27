<template>
  <main :id="skipToContentTargetId" tabindex="-1" class="relative flex-grow">
    <VErrorSection
      v-if="fetchingError"
      :fetching-error="fetchingError"
      class="px-6 py-10 lg:px-10"
    />
    <template v-else-if="audio">
      <VSafetyWall v-if="isHidden" :media="audio" @reveal="reveal" />
      <template v-else>
        <VSingleResultControls :media="audio" />
        <VAudioTrack
          layout="full"
          :audio="audio"
          class="main-track"
          @interacted="sendAudioEvent($event, 'AudioDetailPage')"
        />
        <div
          class="mx-auto mt-10 flex flex-col gap-10 px-6 lg:mt-16 lg:max-w-5xl lg:gap-16"
        >
          <VMediaReuse :media="audio" />
          <VMediaDetails :media="audio">
            <template #thumbnail>
              <div
                class="h-[75px] w-[75px] flex-none overflow-hidden rounded-sm lg:h-30 lg:w-30"
              >
                <VAudioThumbnail :audio="audio" />
              </div>
            </template>
          </VMediaDetails>
          <VRelatedAudio
            @interacted="sendAudioEvent($event, 'VRelatedAudio')"
          />
        </div>
      </template>
    </template>
  </main>
</template>

<script lang="ts">
import { computed, ref } from "vue"
import {
  defineComponent,
  useContext,
  useFetch,
  useMeta,
  useRoute,
} from "@nuxtjs/composition-api"

import { AUDIO } from "~/constants/media"
import { skipToContentTargetId } from "~/constants/window"
import type { AudioDetail } from "~/types/media"
import type { AudioInteractionData } from "~/types/analytics"
import { useAnalytics } from "~/composables/use-analytics"
import { useSensitiveMedia } from "~/composables/use-sensitive-media"
import { singleResultMiddleware } from "~/middleware/single-result"
import { useSingleResultStore } from "~/stores/media/single-result"

import { useSingleResultPageMeta } from "~/composables/use-single-result-page-meta"

import VAudioTrack from "~/components/VAudioTrack/VAudioTrack.vue"
import VMediaReuse from "~/components/VMediaInfo/VMediaReuse.vue"
import VRelatedAudio from "~/components/VAudioDetails/VRelatedAudio.vue"
import VMediaDetails from "~/components/VMediaInfo/VMediaDetails.vue"
import VSafetyWall from "~/components/VSafetyWall/VSafetyWall.vue"
import VSingleResultControls from "~/components/VSingleResultControls.vue"
import VAudioThumbnail from "~/components/VAudioThumbnail/VAudioThumbnail.vue"

export default defineComponent({
  name: "AudioDetailPage",
  components: {
    VAudioThumbnail,
    VSingleResultControls,
    VSafetyWall,
    VMediaDetails,
    VAudioTrack,
    VMediaReuse,
    VRelatedAudio,
  },
  layout: "content-layout",
  middleware: singleResultMiddleware,
  // Fetching on the server is disabled because it is
  // handled by the `singleResultMiddleware`.
  fetchOnServer: false,
  setup() {
    const singleResultStore = useSingleResultStore()

    const route = useRoute()

    const audio = ref<AudioDetail | null>(singleResultStore.audio)
    const fetchingError = computed(
      () => singleResultStore.fetchState.fetchingError
    )

    const { error: nuxtError } = useContext()

    useFetch(async () => {
      const audioId = route.value.params.id
      await singleResultStore.fetch(AUDIO, audioId)

      const fetchedAudio = singleResultStore.audio

      if (!fetchedAudio) {
        nuxtError(singleResultStore.fetchState.fetchingError ?? {})
      } else {
        audio.value = fetchedAudio
      }
    })

    const { sendCustomEvent } = useAnalytics()
    const sendAudioEvent = (
      data: Omit<AudioInteractionData, "component">,
      component: "AudioDetailPage" | "VRelatedAudio"
    ) => {
      sendCustomEvent("AUDIO_INTERACTION", {
        ...data,
        component,
      })
    }

    const { isHidden, reveal, hide } = useSensitiveMedia(audio.value)

    const { pageTitle, detailPageMeta } = useSingleResultPageMeta(audio)

    useMeta(() => ({
      ...detailPageMeta,
      title: pageTitle.value,
    }))

    return {
      audio,
      fetchingError,

      sendAudioEvent,

      skipToContentTargetId,

      isHidden,
      reveal,
      hide,
    }
  },
  head: {},
})
</script>
