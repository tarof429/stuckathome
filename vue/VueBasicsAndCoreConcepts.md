# Vue Basics and Core Concepts

## Introduction

This section covers:

- Templates

- Outputing dynamic content

- Reacting to user input

The example project is basics-01-starting-code.

## Steps

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