<template>
  <section>
    <h2>Select a Topic</h2>
    <!-- What is this for? So that knowledge-grid can refer to topics? -->
    <knowledge-grid :topics="topics" @select-topic="$emit('select-topic', $event)"></knowledge-grid>
  </section>
</template>

<script>
export default {
  props: ['topics'],
  emits: ['select-topic'],
};
</script>w