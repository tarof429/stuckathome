# Vue Basics and Core Concepts

## Introduction

This section covers:

- Templates

- Outputing dynamic content

- Reacting to user input

## Outputing Dynamic Content

The example project is basics-01-starting-code.

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

4. One key option we can set is data. Below, we declare the `data` property to be a function. This function must return an object that is a key-value pair. The key-value pair may be any type, such as string, integer, boolean, or even array.

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

If you want to output some data on an HTML tag, use v-bind instead of interpolation.

```html
<p>Learn more <a v-bind:href="vueLink">about Vue</a>.</p>
```

Instead of using interpolation for a variable, we can also define functions and call them. For example, we can define the following function:

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

Now let's say we want to refer to variables in data() in our funtion, like so: 

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

If our data includes HTML tags, use v-html to interpolate it correctly.

```html
<p v-html="outputGoal()"></p>
```

Note that this is not recommended as it can introduce XSS vulnerabilities.

## Reacting to User Input

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

### Event Modifiers

Suppose we had a form like below:

```html
<form>
    <input type="text">
    <button>Sign up</button>
</form>
```

In traditional HTML, if we click the button the entire page will refresh. To handle this more elegently, we could use `v-on:submit`.

```html
<form v-on:submit="submitForm">
```

Where `submitForm` is our function

```javascript
    submitForm() {
      alert('Submitted');
    }
```

But this still has the default behavior, so we need to add an event modifier to it.

```html
<form v-on:submit.prevent="submitForm">
    <input type="text">
    <button>Sign up</button>
</form>
```

Other event modifiers are:

```
v-on:click.right
v-on:keyup.enter
v-once
```

## Example

The `personal-assignment-1` project illustrates Vue concepts including:

- interpolation
- events and event modifiers
- calling functions
- using variables


