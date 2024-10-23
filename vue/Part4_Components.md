# Introducing Components

## Introduction

We know have a basic grasp of Vue. Now lets look at a problem where we want to do something like hide and show details for items in a list. Below are the steps for how we might implement this, but as we'll see it has limitations.

1. Create a Vue app and mount it to the DOM using an ID.
2. Define data that returns something:

```javascript
const app = Vue.createApp({
    data() {
        return {

        };
    }
});

app.mount('#app');
```

3. Then define our `friends` object:

```javascript
...
  data() {
    return {
        friends: [
            {
                id: 'manual',
                name: 'Manuel Lorenz',
                phone: '01234 5678 991',
                email: 'manuel@localhost.com'
            },
            {
                id: 'julie',
                name: 'Julie Jones',
                phone: '09876 543 221',
                email: 'julie@localhost.com'
            }
        ]
    }
  }
```

4. In our HTML, use `v-for` to iterate through the list of friends

```html
<ul>
    <li v-for="friend in friends">
        <h2>{{ friend.name }}</h2>
        <button @click="toggleDetails">
            {{ detailsAreVisible ? 'Hide' : 'Show' }} Details</button>
        <ul v-if="detailsAreVisible">
        <li><strong>Phone:</strong>{{ friend.phone }}</li>
        <li><strong>Email:</strong>{{ friend.email }}</li>
        </ul>
    </li>
</ul>
```

We then add a method called `toggleDetails()`:

```javascript
...
methods: {
    toggleDetails() {
        console.log('Toggling details')
        this.detailsAreVisible = !this.detailsAreVisible;
    }
}
```

However, this button does not work as expected. It does not hide or show individual friends, but rather hides and shows all friends. The toggleDetails method just does not know which friend details to toggle. 

To fix this, we need to look at components.

## Components

Components allow us to split the UI into independent and reusable pieces, and think about each piece in isolation. It's common for an app to be organized into a tree of nested components.

To create a component, we write:

```javascript
app.component('friend-contact');
```

It's important to include a `-` in the id of the component so that it's isolated from Vue's own components. We do not want to name our component `h2` for example because Vue already has such a component.

The second argument to a component is a config object that is essentially a Vue app! 

Now we can move a chunk of our Javascript code from the main app to our component, so that our code now looks like this:

```javascript
app.component('friend-contact', {
    data() {
        return {
            detailsAreVisible: false
        }
    },

    methods: {
        toggleDetails() {
            console.log('Toggling details')
            this.detailsAreVisible = !this.detailsAreVisible;
        }
    }
}); 

```

And now to get interpolation to work, we'll remove the `v-for` property and for now add it to our component like this:

```javascript
friend: 
{
    id: 'manual',
    name: 'Manuel Lorenz',
    phone: '01234 5678 991',
    email: 'manuel@localhost.com'
},
```

Now we can add our component to the HTML as if it was an official HTML tag.

```html
<friend-contact></friend-contact>
```

We also need to define a `template` which will provide the HTML content that will be rendered on screen. To create our template, we simply move the HTML used to render the list items into our Javascript in back-ticks for multiple lines:

```javascript
app.component('friend-contact', {
    template: `
    <li>
        <h2>{{ friend.name }}</h2>
        <button @click="toggleDetails">{{ detailsAreVisible ? 'Hide' : 'Show' }} Details</button>
        <ul v-if="detailsAreVisible">
            <li><strong>Phone:</strong>{{ friend.phone }}</li>
            <li><strong>Email:</strong>{{ friend.email }}</li>
        </ul>
    </li>
    `,
    ...
```

{% hint style="info" %}
You must create the component before you mount the app!
{% endhint %}

Now when we refresh the page we are able to expand contact details. We still don't know how to do this for multiple contacts; this will be covered later.

## Conclusion and next steps

Components allow us to create reusable HTML content that can communicate with the main Vue app. To the developer, it is like implementing HTML tags which we can place anywhere on our page as we please.

Next, we look at a better development model.