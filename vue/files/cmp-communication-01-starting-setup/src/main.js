import { createApp } from 'vue';

import App from './App.vue';
import FriendContact from './components/FriendContact.vue';
import NewFriend from './components/NewFriend.vue'; // Import the NewFriend component

const app = createApp(App);

// Make components available globally in the current Vue application
app.component('friend-contact', FriendContact);
app.component('new-friend', NewFriend);

// Optionally the app.component() method can be chaned:
// app
//     .component('friend-contact', FriendContact)
//     .component('new-friend', NewFriend);

app.mount('#app');
