# Vue Behind the Scenes

## Dealing with user input

The typical way of retrieving user input in a field is to use the `@input`attribute in the HTML, and then use a method to retrieve that value in the Javascript.

```html
<input type="text" @input="saveInput">
```

```javascript
saveInput(event) {
    this.currentUserInput = event.target.value;
},
```

If we use this technique, every character that the user types becomes part of the target value. This is because the input listener listens to every keystroke. An alternative approach is to use v-model which will read the entire string in one pass. 

Yet another approach is to use something called refs. Like v-model, the value is read from the DOM only once. You use refs by adding a special attribute to an HTML element called `ref`. 

In the Javascript, refs are accessed with

```
this.$refs.
```

Within refs is a list of key-value pairs consisting of ref identifiers that we define. Now when write

```
this.$refs.userInput
```

we are accessing the DOM element whose ref ID is userInput. 

Now if we write code like 

```
console.log(this.$refs.userInput);
```

and view the output in the browser console, we se a long list of key value pairs, one of which is `value` which contains the actual value. Hence to access this value, we can write:

```
this.message = this.$refs.userInput.value;
```

## Lifecycle Hooks

Sometimes you'd like to troubleshoot a Vue app. One way to do this is to define methods outside of the `methods()` block. For example, we can define a method called `beforeCreate() and set a breakpoint in it.

```
  beforeCreate() {
    console.log('beforeCreate()')
  }
```

Nothing will be rendered on the screen, so we know that we have set a breakpoint at a point in time before Vue renders on the screen. 

Other methods (hooks) we can add are:

- beforeCreate()
- created()
- beforeMount()
- mounted()
- beforeUpdate()
- updated()
- beforeUnmount()
- unmounted()

