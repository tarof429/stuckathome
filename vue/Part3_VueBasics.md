# Vue Basics

## Vue Components

## Introduction

This section covers:

- Templates

- Outputing dynamic content

- Reacting to user input

## Outputing Dynamic Content

The section is based on `17. Creating and Connecting Vue App Instances`. See the example project in `part3/basics-01-starting-code`.

Vue lets us output dynamic content. To do that, first create an app.

1. In the Javascript file, create an App().

```javascript
const app = Vue.createApp();
```

2. Mount the app by specifying a CSS selector. In our case, we choose `#user-goal`, an ID that is unique to the page.

```javascript
app.mount('#user-goal')
```

3. Next, we configure the app by passing an object to it. Initially it looks something like this:

```javascript
const app = Vue.createApp({
    
});
```

4. Vue makes it easy to display data. Below, we declare the `data` option to be a function. This function must return an object (sometimes referred to as a property) that is a key-value pair. The key-value pair may be any type, such as string, integer, boolean, or even array.

```javascript
const app = Vue.createApp({
    data() {
        return {
            courseGoal: 'Finish the course and learn Vue!'
        };
    }
});
```

We can then use refer to `courseGoal` in our HTML using interpolation: 

```html
<section id="user-goal">
    <h2>My Course Goal</h2>
    <p>{{ courseGoal }}</p>
</section>
```

If you want to output some data between HTML tags such as the anchor tag, we have to use v-bind. If you look back at the code example, `vueLink is a property whose value points to an external website. 

```html
<p>Learn more <a v-bind:href="vueLink">about Vue</a>.</p>
```

Instead of using interpolation for a variable value such as courseGoal, we can also define functions and call them. For example, we can define the following function:

```javascript
methods: {
    outputGoal() {
        const randomNumber = Math.random();
        if (randomNumber < 0.5) {
            return 'Learn Vue!';
        } else {
            return 'Master Vue!';
        }
    }
}
```

Then in our HTML, we call the function like so: 

```html
<p>{{ outputGoal() }}</p>
```

On the other hand, let's say we want to refer to variables in data() in our funtion. 

```javascript
data() {
    return {
        courseGoal: 'Finish the course and learn Vue!',
        courseGoalA: 'Finish the course and learn Vue!',
        courseGoalB: 'Finish the course and master Vue!',
        vueLink: 'http://vuejs.org'
    };
},
```

How do we refer to these variables in our function? Use `this`. 

```javascript
outputGoal() {
    const randomNumber = Math.random();
    if (randomNumber < 0.5) {
        return this.courseGoalA;
    } else {
        return this.courseGoalB;
    }
}
```

Now, the `basics-01-starting-code example` isn't very useful, so we add a method to the table example in `basics-02-table` to show how methods can be used to return values.

## Reacting to User Input

In this next section, we talk about how to reac to user input. This include button clicks.

### Basics

To react to button clicks, we can use `v-on`. The code below increments the counter variable when the user clicks the Add button (this snippet is from `basics-03-events-starting-code`).

```
<button v-on:click="counter++">Add</button>
```

We could also call a function: 

```html
<button v-on:click=increment()>Add</button>
```

which is defined as: 

```javascript
increment() {
    this.counter++;
}
```

The resulting Javascript would look something like this:

```javascript
methods: {
    increment() {
        this.counter++;
    },

    decrement() {
        this.counter--;
    }
}
```

Earlier the HTML contained the line

```html
<button v-on:click=increment()>Add</button>
```

But this could be rewritten

```html
<button v-on:click="increment">Add</button>
```

Vue will figure it out.

We can also use functions with arguments. Here in the HTML:

```html
<section id="events">
    <h2>Events in Action</h2>
    <button v-on:click=increment(5)>Add</button>
    <button v-on:click=decrement(5)>Remove</button>
    <p>Result: {{ counter }}</p>
</section>
```

And this is what the methods would look like:

```javascript
methods: {
increment(num) {
    this.counter = this.counter + num;
},

decrement(num) {
    this.counter = this.counter - num;
}
```

We can also add event listeners to input fields. Here it is import to use the v-on event listener with a function that we define but refer to it as an object and not as a function. 

```html
<input type="text" v-on:input="setName">
<p>Your Name: {{ name }}</p>
```

This allows us to write JavaScript like

```javascript
setName(event) {
    this.name = event.target.value;
}
```

But if we still need to pass a value from the HTML to the Javascript without relying exclusively on `event.target.value`, we could use the reserved keyword `$event`

```
<input type="text" v-on:input="setName($event, 'Kermit')">
```

and then in the Javascript

```javascript
setName(event, name) {
    this.name = event.target.value + ' ' + name;
```

In respect to the tables example, this might mean adding a button to scan for new servers. To enable this, we might want to replace the static array of servers with a function that returns a list of servers. We could think of this as a prototype of a web application that scans the network.

The `files/part3/basics-04-table` example illustrates the use of v-on to handle button clicks to generate a dynamic list. To display icons, we use v-html. 