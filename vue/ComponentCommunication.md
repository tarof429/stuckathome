# Component Communication

## Introduction

This section uses the `cmp-communcation-01-starting-setup` example. To get this project started, 

1. First adrun `npm install`. 

2. Next, to run this example, run `npm run serve`.

The problem we face at the outset of this project is how to display multiple contacts. We want to reuse the template so that it can be used with different data. The solution is to use something called `props`. We need to tell Vue about the properties we want to expose to the component. 

## Adding Props

Initially our FriendContact component looks like this:

```
export default {
    data() {
        return {
            ...
        },
    },

    methods() {

    }
```

With props, it now looks like this:

```
export default {
    props: [
        'name',
        'phoneNumber',
        'emailAddress'
    ],
```

Next, we change our template in our component to use these properties:

```html
<template>
  <li>
    <h2>{{ name }}</h2>
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
  </li>
</template>
```

Finally in App.vue, we define our data

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

## Parent-child communication

If we want a parent component to talk to a child component, we use props. One thing to keep in mind is that props should not be mutated. 

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

The other approach is to treat the received data as the initial data and therefore we aren't changing the original data. 

In our FriendContact component, we add an addition data property called friendIsFavorite, and set it to the prop value. 

```
friendIsFavorite: this.isFavorite
```

Then in our componet, instead of using the `isFavorite` prop, we use the friendIsFavorite data property.

From

```
<h2>{{ name }} {{ isFavorite == '1' ? '- (Favorite)' : ''}}</h2>
```

to

```
<h2>{{ name }} {{ friendIsFavorite == '1' ? '- (Favorite)' : ''}}</h2>
```

We also change our method to

```javascript
toggleFavorite() {
    this.friendIsFavorite == '1' ? this.friendIsFavorite = '0' : this.friendIsFavorite = '1';
}
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

To bind data to properties, we use v-bind. Below, we map properties defined in our component to our data defined in App.vue. 

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

This can be considered parent-child (what I think of as "downstream") communcation.

## Child-parent communication

With props, we are able to implement parent-child communication. To do the revers, we need to implement custom events.  

To let Vue know about the events you will emit, you can add an emit section to document the fact that your application emits custome events with a particular identifier. 

```javascript
emits: ['toggle-favorite']
```

## Implementing the `New Friend` component

Now let's add another component to our application. The component will let us add a friend.

The NewFriend component contains a form with some fields and a button that will add the friend. We define some data and bind them to each field. Finally, we add a method called submitData() which will emit an event that will add the new friend. 

## Deleting Friends.

We don't need a new component to delete a Friend but we do need a button. This button is added to the FriendContact component and it emits an event that will delete the contact.


## Summary

Props are used to send data into a component while events are there to send data out of a component.

