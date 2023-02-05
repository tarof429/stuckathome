<template>
  <li>
    <h2>{{ friendName }} {{ isFavorite ? '(Favorite)' : ''}}</h2>
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
    <button @click=deleteContact>Delete</button>
  </li>
</template>

<script>
export default {
  props: {
    id: { type: String, required: true},
    friendName: { type: String, required: true},
    phoneNumber: { type: String, required: true},
    emailAddress: { type: String, required: true},
    isFavorite: { type: Boolean, required: false, default: false},
  },

  emits: ['toggle-favorite'],
  
  data() {
    return {
      detailsAreVisible: false,
      // friendIsFavorite: this.isFavorite
    };
  },
  methods: {
    toggleDetails() {
      this.detailsAreVisible = !this.detailsAreVisible;
    },

    toggleFavorite() {
      //this.friendIsFavorite = !this.friendIsFavorite;
      // emit a custom event
      this.$emit('toggle-favorite', this.id); 
    },
    
    deleteContact() {
      this.$emit('delete-contact', this.id);
    }
  }
};
</script>