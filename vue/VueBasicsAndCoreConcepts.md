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

4. One key option we can set is data. Below, we declare the `data` option to be a function. This function must return an object that is a key-value pair. The key-value pair may be any type, such as string, integer, boolean, or even array.

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

## How to Implement a "Reset" button

Let's say we want to implement a "reset" button. Initially it will look something like this:

```
 <button>Reset</button>
 ```

 This can be modified to call a method:

 ```
 <button v-on:click="reset">Reset</button
 ```

 and we define the reset method like below.

```javascript
reset() {
    this.name = 0;
}
```

But this doesn't work. What you have to do is add a property to input like:

```
<input type="text" v-bind:value="name" v-on:input="setName($event, 'Schwarzmüller')">
```

And now it works! We are not only setting a value, we are getting the value. To simplify the code, we can use `v-model`. to cover both scenarios. It's a shortcut for v-bind:value and v-on:input. This is a concept called "two-way binding". 

{% hint style="info %}
Use `v-model` whenever you want to connect input from the user to a data property. For example if in the HTML we have:

```html
<input type="text" v-model="name">
```

Then in app.js we can add a property for name:

```javascript
  data() {
    return {
      name: ''
    };
  },
```
{% endhint %}

## Computed Properties

Besides data and methods, there is a third property called `computed`. You should use it whenever you want to set the value of a field and don't want it re-rendered over and over again. Compared to methods, a computed prooperty is aware of what properties change. Use computed properties to improve the performance of your Vue app. 

For example, the value of the computed property below depends on the value of `hostname`.  

```javascript
computed: {
    computedId() {
        if (this.hostname == '' || this.hostname == 'localhost') {
        return '';
        }

        return this.hostname;
},
```

## Watchers

Watchers are used to compute values for one field. If you want to use multiple fields, computed properties is an easier approach. For example:

```javascript
watch: {
    name(value) {
        if (value == '') {
            this.fullname = '';
        } else {
            this.fulllname = value + ' ' + this.lastName;
        }

    },

    lastname(value) {
        ...
    }
}
```

A good case for using a watcher is if we want to monitor the value of a field and trigger a behavior. For example, we want to trigger a behavior if the counter exceeds a value.

## Shortcuts

A shortcut for `v-on:click` is `@click`. Note: it is not :click!

A shortcut for `v-bind:value` is `:value`. 

## Dynamic Styling

The `basics-10-styling-starting-setup` is an example of how to do dynamic styling with Vue. There are two ways to do this. One way is shown below. This example uses the `@click` event listener along with the `v-bind:style` (or just `:style`) dynamic styling attribute to dynamically set the CSS style on an element. Note that we define the style as an object. Below:

```html
<div class="demo" :style="{borderColor: boxASelected ? 'red' : '#ccc'}" @click="boxSelected('A')"></div>
```

What we are doing is setting the inline style of an object (hence the braces) by writing a ternary expression to dynamically set our style.

Besides `:style`, another was is to use `:class`. The `basics-10-styling-starting-setup-1` below shows how to do this. Below is how `:class` and `:style` can be used together, but can be a bit confusing and is not recommeded.

```html
<div :class="boxASelected ? 'demo active' : 'demo'" :style="{borderColor: boxASelected ? 'red' : '#ccc'}" @click="boxSelected('A')"></div>
```

A better way is to just use `:class`:

```html
<div class="demo" :class="{active: boxASelected}" @click="boxSelected('A')"></div>
``` 

Also note that we can toggle the CSS style by writing the following Javascript code:

```javascript
this.boxASelected = !this.boxASelected;
```

The `basics-10-styling-starting-set-2` example uses `:class` and computed properties to change CSS class styles. Earlier we wrote

```html
<div class="demo" :class="{active: boxASelected}" @click="boxSelected('A')"></div
```

and created an inline object in `:class` to set the class. Instead of inline objects, we can use computed properties as shown below:

```javascript
computed: {
    boxAClasses() {
        return { active: this.boxASelected };
    }
},
```

And we refer to it as:

```html
<div class="demo" :class="boxAClasses" @click="boxSelected('A')"></div>
```

Note that Vue also supports passing in an array of CSS classes. In the examle below, we always set the `demo` class, and conditionally set the `boxBSelected` class.

```html
<div :class="['demo', {active: boxBSelected}]">
```

## Basic Assignment 4

In this example, we are given a few problems. The first problem is to fetch the user input and set it as a CSS class.

In the HTML all we need to do set `v-model`:

```html
<input type="text" v-model=enteredClass />
<p :class=enteredClass>
Style me!
</p>
```

and we define the enteredClass property in our Javascript.

```javascript
data() {
    return {
        enteredClass: ''
    }
}
```

If we don't want to set a class on every keystroke, if we want to limit what classes are applied, we can instead limit our choices inline:

```html
<p :class="{user1: enteredClass === 'user1', user2: enteredClass === 'user2'}">
```

We can also put this into a computed property to reduce the amount of code in our HTML. In our Javascript:

```javascript

```


<p :class="paraClasses">
