# Rendering Conditional Content And Lists

## Introduction

Sometimes we need to display items conditionally. For example, imagin we have a list of to-do items. If there are no items in the list, we want to display a message. But if there are items in the list, we want to display the items instead. This section convers both of these scenarios.

## The v-if directive

To display items conditionally, use the `v-if` directive. For example, in `lists-cond-01-starting-setup`, we have the code:

```
<p>No goals have been added yet - please start adding some!</p>
```

We can change this to read

```
<p v-if="goals.length === 0">No goals have been added yet - please start adding some!</p>
```

Vue also supports `v-else` and `v-else-if` which must follow `v-if`. 

There is another directive called `v-show`. While `v-else` adds and removes elements from the DOM, `v-show` simply hides them. Most of the time, `v-else` is preferred as it keeps the DOM clean. Use `v-show` if an element changes visibility often. 

To loop through items in a list, use `v-for`.

```
<li v-for="goal in goals">{{ goal }}</li>
```

With `v-for`, we also have access to the index.

```
<li v-for="(goal, index) in goals">{{ goal }} - {{ index }}</li>
```

For loops aren't limited to just simple types like strings. We can also loop through an array of objects. For example, say we have an array of users:

```
users: [
    {
        first: 'John',
        last: 'Doe'
    },
    {
        first: 'Mary',
        last: 'Scotts'
    }
]
```

Then the following code can be used to loop through these users.

```
<li v-for="user in users">{{ user.first }} {{ user.last }}<
```

We can also loop through a range of numbers:

```
<li v-for="num in 10">{{ num }}</li>
```

To summarize, you can loop through items in a list in Vue using code like this:

```html
<ul>
<li v-for="goal in goals">{{ goal }}</li>
</ul>
```

Note that the loop starts at the `<li>` level, not the `<ul>` level.

## Removing List Items

Remove items from a list is easy. What we want to do is remove a goal from the array of goals:

```html
<li id="item" v-for="(goal, index) in goals" @click="removeGoal(index)">{{ goal }}</li>
```

Back in the Javascript, we can use the `splice` method to remove that one element.

```javascript
removeGoal(index) {
    this.goals.splice(index, 1);
}
```

It's that easy!

## Common Gotchas and how to fix them

Sometimes you need to use the @click.stop modifier to prevent event listeners from propagating to inner DOM elements.

```html
<li id="item" v-for="(goal, index) in goals" @click="removeGoal(index)">{{ goal }}>
    <p>{{ goal }} - {{ index }}</p>
    <input type="text" @click.stop>
</li>
```

To fix this, add the `key` attribute and pass in a unique key.

```html
<li id="item" v-for="(goal, index) in goals" :key="goal" @click="removeGoal(index)">{{ goal }}>
    <p>{{ goal }} - {{ index }}</p>
    <input type="text" @click.stop>
</li>
```
