<template>
  <!-- @todo: Separate the absolute container from the link itself. -->
  <VButton
    as="VLink"
    :href="href"
    has-icon-start
    variant="transparent-gray"
    size="small"
    class="label-bold inline-flex"
    v-bind="$attrs"
    @mousedown="handleClick"
  >
    <VIcon name="chevron-left" :rtl-flip="true" />
    {{ $t("singleResult.back") }}
  </VButton>
</template>

<script lang="ts">
import { defineComponent } from "vue"

import { useAnalytics } from "~/composables/use-analytics"
import { useSearchStore } from "~/stores/search"

import VIcon from "~/components/VIcon/VIcon.vue"
import VButton from "~/components/VButton.vue"

/**
 * This link takes the user from a single result back to the list of all
 * results. It only appears if the user navigated from the search results.
 */
export default defineComponent({
  components: {
    VIcon,
    VButton,
  },
  props: {
    /**
     * The unique ID of the media
     */
    id: {
      type: String,
      required: true,
    },
    href: {
      type: String,
      required: true,
    },
  },
  setup(props) {
    const { sendCustomEvent } = useAnalytics()
    const searchStore = useSearchStore()

    const handleClick = () => {
      sendCustomEvent("BACK_TO_SEARCH", {
        id: props.id,
        searchType: searchStore.searchType,
      })
    }

    return {
      handleClick,
    }
  },
})
</script>
