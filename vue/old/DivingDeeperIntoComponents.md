# Diving Deeper into Components

This section covers:

- Advanced component registration and styling
- Slots and dynamic components
- Naming and folder structure

## Registering components globally

To register components globally, use the `component` method on the Vue App object as we have been doing.

Some drawbacks:

- If you have hunderds of components this could be a very long list
- Not all components need to be global
- The application wil take longer to load

## Registering components locally

In App.vue, we can add a components section to keep the components local. 

```javascript
<script>
import TheHeader from './components/TheHeader.vue';
...
export default {
  components: {
    'the-header': TheHeader
  },
```

## Scoped Styling

Simply add the `scoped` attributed on the `<style>` tag to force styles in a .vue file to only affect components defined in that file.

## Slots

Slots are a way to create a reusable component for styling. To use slots, 

- First create a component with the template and style sections and register it with Vue
- Within the template, add a slots section where you want your HTML to be displayed
- Now you can use your slot in another component

See the cmp-adv-01-starting-setup example.

