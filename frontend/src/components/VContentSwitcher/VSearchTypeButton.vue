<template>
  <VButton
    class="min-w-12 gap-x-2"
    :class="showLabel ? '!px-3' : 'w-12'"
    variant="bordered-white"
    size="large"
    :aria-label="$t('searchType.selectLabel', { type: label })"
    v-bind="$attrs"
    @click="$emit('click')"
  >
    <VIcon :name="searchType" class="h-6 w-6" />
    <template v-if="showLabel">
      <span class="label-regular block truncate text-start">{{ label }}</span>
      <VIcon name="caret-down" />
    </template>
  </VButton>
</template>
<script lang="ts">
import { defineComponent, PropType } from "vue"

import type { SearchType } from "~/constants/media"

import { warn } from "~/utils/console"

import VIcon from "~/components/VIcon/VIcon.vue"
import VButton from "~/components/VButton.vue"

/**
 * This is the search type switcher button that appears in the header or the homepage search bar.
 */
export default defineComponent({
  name: "VSearchTypeButton",
  components: { VButton, VIcon },
  props: {
    /**
     * Whether to show the text label and the chevron down.
     */
    showLabel: {
      type: Boolean,
      default: false,
    },
    searchType: {
      type: String as PropType<SearchType>,
      required: true,
    },
    icon: {
      type: String,
      required: true,
    },
    label: {
      type: String,
      required: true,
    },
  },
  setup(_, { attrs }) {
    if (!attrs["aria-haspopup"] || attrs["aria-expanded"] === undefined) {
      warn(
        "You should provide `aria-haspopup` and `aria-expanded` props to VSearchTypeButton."
      )
    }
  },
})
</script>
