<template>
  <section>
    <header>
      <h1>My Friends</h1>
    </header>
    <p v-if="duplicateContact">Contact already exists!</p>
    <new-friend
      :contactName="friendName"
      :phoneNumber="phone"
      :emailAddress="email"

      @add-contact="addNewContact"
      @check-if-friend-already-exists="friendCheck"
    ></new-friend>
    <ul>
      <!-- Below, we set prop values for each FriendContact component-->
      <!-- Communication is parent to child -->
      <!-- v-bind is used for true/false fields-->
      <!-- <friend-contact
        name="John Doe"
        phone-number="12345"
        email-address="john@localhost.com"
        v-bind:is-favorite="true"
        >

      </friend-contact>
      <friend-contact
        name="Mary Jane"
        phone-number="6789"
        email-address="mary@localhost.com"
        v-bind:is-favorite="false"
        >
      </friend-contact> -->

      <!-- prop name in the FriendContact is mapped (v-bind) to 
        the data field name in the parent. 
        :key is required for a for loop. We don't need to specify the 
        id in the component. 
        :name is shorthand for v-bind:name 
        binding prop values dynamically
      -->
      <friend-contact
        v-for="friend in friends"
        :key="friend.id"
        :id="friend.id"
        :name="friend.name"
        :phone-number="friend.phone"
        :email-address="friend.email"
        :is-favorite="friend.isFavorite"
        @toggle-favorite="toggleFavoriteStatus"
        @delete="deleteContact"
      ></friend-contact>
    </ul>
  </section>
</template>

<script>
// This can also be done in main.js
// import FriendContact from './components/FriendContact.vue';

export default {
  // What for?
  components: { FriendContact, NewFriend },
  data() {
    return {
      friends: [
        {
          id: "manuel",
          name: "Manuel Lorenz",
          phone: "0123 45678 90",
          email: "manuel@localhost.com",
          isFavorite: false
        },
        {
          id: "julie",
          name: "Julie Jones",
          phone: "0987 654421 21",
          email: "julie@localhost.com",
          isFavorite: false
        },
      ],
      duplicateContact: false,
    };
  },

  methods: {
    toggleFavoriteStatus(friendId) {
      const identifiedFriend = this.friends.find(
        friend => friend.id === friendId);
      identifiedFriend.isFavorite = !identifiedFriend.isFavorite;
    },

    addNewContact(contactName, contactPhone, contactEmail) {

      //console.log('Adding a new friend');
      if (this.friends.find(friend => friend.friendName === contactName)) {
        this.duplicateContact = true;
        return;
      } else {
        this.duplicateContact = false;
      }

      const newFriendContact = {
        id: new Date().toISOString(), 
        name: contactName, 
        phone: contactPhone, 
        email: contactEmail, 
        isFavorite: false
      }

      this.friends.push(newFriendContact);
    },


    deleteContact(friendId) {
      // filter is a Javascript function that can be applied to an array
      // The filter function needs a function
      this.friends = this.friends.filter((friend) => friend.id !== friendId);
    }
  }
};
</script>

<style>
* {
  box-sizing: border-box;
}
html {
  font-family: "Jost", sans-serif;
}
body {
  margin: 0;
}
header {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.26);
  margin: 3rem auto;
  border-radius: 10px;
  padding: 1rem;
  background-color: #58004d;
  color: white;
  text-align: center;
  width: 90%;
  max-width: 40rem;
}
#app ul {
  margin: 0;
  padding: 0;
  list-style: none;
}
#app li,
#app form,
#app p {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.26);
  margin: 1rem auto;
  border-radius: 10px;
  padding: 1rem;
  text-align: center;
  width: 90%;
  max-width: 40rem;
}

#app p {
  font-weight: bold;
  color: #ec3169;
}
#app h2 {
  font-size: 2rem;
  border-bottom: 4px solid #ccc;
  color: #58004d;
  margin: 0 0 1rem 0;
}
#app button {
  font: inherit;
  cursor: pointer;
  border: 1px solid #ff0077;
  background-color: #ff0077;
  color: white;
  padding: 0.05rem 1rem;
  box-shadow: 1px 1px 2px rgba(0, 0, 0, 0.26);
}
#app button:hover,
#app button:active {
  background-color: #ec3169;
  border-color: #ec3169;
  box-shadow: 1px 1px 4px rgba(0, 0, 0, 0.26);
}

#app input {
  font: inherit;
  padding: 0.15rem;
}

#app label {
  font-weight: bold;
  margin-right: 1rem;
  width: 7rem;
  display: inline-block;
}

#app form div {
  margin: 1rem 0;
}

</style>