# Component Communication

## Introduction

This section uses the `cmp-communcation-01-starting-setup` example. To get this project started, 

1. First run `npm install`. 

2. Next, to run this example, run `npm run serve`.

The problem we face at the outset of this project is how to create a contact and have it added to our list of contacts. In order to do this, our contacts need to be defined in the parent component not in the child component. So how do we create the contact and have it added to the parent? The solution is to use something called `props`.

## What are props?

Props, or properties, is a concept that you can think of as custom HTML attributes for a component. This is because components by themselves don't expose any data to the parent component. 

## Example

In App.vue, we would like to list contacts with different atrtibutes and with different data, something like below:

```xml
<template>
  <section>
    <header>
      <h1>My Friends</h1>
    </header>
    <ul>
      <friend-contact
        name="Manual Lorenz"
        phone-number="01234 5311"
        email-address="manual@localhost.com">
      </friend-contact>
      <friend-contact
        name="Julie Andrews"
        phone-number="9482 1984"
        email-address="julie@localhost.com">
      </friend-contact>
    </ul>
  </section>
</template>
```

In order to use props inside of components like this, we also need to write some code inside the component. We need to make Vue aware of the props that you want to accept in our component. That code looks like this:

```javascript
props: ['id', 'name', 'phoneNumber', 'emailAddress', 'isFavorite']
```

And that's how we use props to communicate data from parent to child components.

## Parent-child communication

One thing to keep in mind is that props should not be mutated. 

Let's suppose we add a prop called `is-favorite` to our FriendContact component.

Next, we add a button and an event listener to toggle this property.

```javascript
toggleFavorite() {
    this.isFavorite == '1' ? this.isFavorite = '0' : this.isFavorite = '1';
}
```

If we try to save this file, we get an error saying `Unexpected mutation of "isFavorite" prop.

Why does this happen?

## Unidirectional data flow

Unidrectional data flow means "data passed from the parent component to the child component should only be changed in the parent component". 

There are two ways to fix this. One way is to let the parent component know that we want to change this property. 

The other approach is to treat the received data as the initial data and we don't change the original data. 

In our FriendContact component, we add an addition data property called friendIsFavorite, and set it to the prop value. 

```javascript
  props: {
    ...
    isFavorite: { type: Boolean, required: false, default: false},
  },
```

We change the method to toggle isFavorite to emit an event.

```javascript
  toggleFavorite() {
    //this.friendIsFavorite = !this.friendIsFavorite;
    // emit a custom event
    this.$emit('toggle-favorite', this.id); 
  },
```

Finally in App.vue, we listen to the toggle-favorite event and point to a method.

```javascript
@toggle-favorite="toggleFavoriteStatus"
```

Finally, toggleFavoriteStatus will change the flag.

```javascript
  toggleFavoriteStatus(friendId) {
    const identifiedFriend = this.friends.find(
      friend => friend.id === friendId);
    identifiedFriend.isFavorite = !identifiedFriend.isFavorite;
  },
```

## Data types of props

In our example, we defined props as an array:

```javascript
  props: [
    'name',
    'phoneNumber',
    'emailAddress',
    'isFavorite'
  ],
```

You can also define it as an object with the data type.

```javascript
props: {
  name: String,
  phoneNumber: String,
  emailAddress: String,
  isFavorite: String
},
```

Below is example where we define props and define further attributes for each property as an object.

```javascript
props: {
  name: { type: String, required: true},
  phoneNumber: { type: String, required: true},
  emailAddress: { type: String, required: true},
  isFavorite: { type: String, required: false, default: '0'},
},
```

Below is yet another example where we add validation for the isFavorite property.

```javascript
  props: {
    name: { type: String, required: true},
    phoneNumber: { type: String, required: true},
    emailAddress: { type: String, required: true},
    isFavorite: { type: String, required: false, default: '0', 
      validator: function(value) {
        return value == '1' || value == '0';

    }},
  },
```

## Binding data to props

To bind data to properties, we use v-bind. Below, we map properties defined in our component to our data defined in App.vue. Here, `:key` is shorthand for `v-bind:key` for example. The field on the left of the equals sign comes from the compoennt, whele the field on the right side is in App.vue.

```javascript
<ul>
  <friend-contact
    v-for="friend in friends"
    :key="friend.id"
    :name="friend.name"
    :phoneNumber="friend.phone"
    :emailAddress="friend.email"
    :is-favorite="true">
  </friend-contact>
</ul>
```

## Custom Events

With props, we are able to pass data from the App.vue file to the child component. To do the reverse, we need to implement custom events.  

To create a custom event, we use `$emit`, a built in method, from inside our component:

```javascript
  toggleFavorite() {
    // emit a custom event
    this.$emit('toggle-favorite', this.id); 
  },
```

`$emit()` needs at least one argument, the name of the custom event. 

To let Vue know about the events you will emit, you can add an emit section in our component. 

```javascript
emits: ['toggle-favorite']
```

To listen to the event, in App.vue we add the listener to the component and bind it to a method inside App.vue. 

```javascript
      <friend-contact
        v-for="friend in friends"
        ...
        // Long format: v-on:toggle-favorite
        @toggle-favorite="toggleFavoriteStatus"
```

## Implementing the `New Friend` component

Now let's add another component to our application. The component will let us add a friend.

The NewFriend component contains a form with some fields and a button that will add the friend. We define some data and bind them to each field. Finally, we add a method called submitData() which will emit an event that will add the new friend. 

## Deleting Friends.

We don't need a new component to delete a Friend but we do need a button. This button is added to the FriendContact component and it emits an event that will delete the contact.

## A Complicated Example

The `cmp-communication-08-a-potential-problem` illustrates a potential problem you'll encounter with Vue. What is actually going on here?

- ActiveElemnent displays `topicTitle` and `text` which are received as props
- In App.vue, `topicTitle` and `text` are provided by the value of `activeTopic` which is defined in App.vue
- Initially, `activeTopic` is null but is set when `activeTopic()` is invoked by the KnowledgeBase Component 
- The KnowledgeBase component receives a props of topics and emits an event called `select-topic`
- KnowledgeBase is acting like a pass-through component


## Summary

Props are used to send data into a component while events are there to send data out of a component.

