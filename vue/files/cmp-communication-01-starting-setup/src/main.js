import { createApp } from 'vue';

import App from './App.vue';
import FriendContact from './components/FriendContact.vue';
import NewFriend from './components/NewFriend.vue'; // Import the NewFriend component

const app = createApp(App);

app.component('friend-contact', FriendContact);
app.component('new-friend', NewFriend); // Register NewFriend as a component with an ID of 'new-friend'

app.mount('#app');
