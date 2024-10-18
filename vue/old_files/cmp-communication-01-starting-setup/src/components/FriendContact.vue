<template>
  <li>
    <!-- name is a prop that we can use as if it was a data -->
    <h2>{{ name }} {{ isFavorite ? '(Favorite)' : ''}}</h2>
    <button @click="toggleFavorite">Toggle Favorite</button>
    <button @click="toggleDetails">{{ detailsAreVisible ? 'Hide' : 'Show' }} Details</button>
    <ul v-if="detailsAreVisible">
      <li>
        <strong>Phone:</strong>
        {{ phoneNumber }}
      </li>
      <li>
        <strong>Email:</strong>
        {{ emailAddress }}
      </li>
    </ul>
    <button @click="$emit('delete', id)">Delete</button>
  </li>
</template>

<script>
export default {
  // Shorter format, without the type
  // Prop names must not contain '-'
  // props: ['id', 'name', 'phoneNumber', 'emailAddress', 'isFavorite'],

  // Longer format, as an object, will let us specify the data type
  props: {
    id: { type: String, required: true},
    name: { type: String, required: true},
    phoneNumber: { type: String, required: true},
    emailAddress: { type: String, required: true},
    isFavorite: { type: Boolean, required: false, default: false},
  },

  // Let the developer know what custom events will be emitted
  emits: ['toggle-favorite', 'delete'],
  
  data() {
    return {
      detailsAreVisible: false,
    };
  },
  methods: {
    toggleDetails() {
      this.detailsAreVisible = !this.detailsAreVisible;
    },

    toggleFavorite() {
      this.$emit('toggle-favorite', this.id); 
    },
    
  }
};
</script>