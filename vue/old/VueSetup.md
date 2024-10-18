# Moving to a Better Development Setup & Workflow with the Vue CLI

# Using the Vue CLI

```
vue create <project>
```

For example:

```
vue create first-app
```

Thereafter, we can use npm to serve the application over the network.

```
cd first-app
npm run serve
```

## Installing node modules

The `files/vue-cli-01-a-new-vue-project` example does not contain node modules. The first step to get this example working is to isntall the node modules.

```
npm install
```

Afterwards we can run the npm server.

```
npm run serve
```

If we visit `http://localhost:8080` we won't see anything, so the next step is to write our components.

## Adding components

1. First, create src/App.vue which will contain the configuration for our application. 

2. Next, add a template section.

```
<template></template>
```

3. Next we will add a script section.

```
<script></script>
```

4. Now we will proceed to implement the `files/cmp-intro-01-starting-setup` example which uses components. Our scripts section now looks like this:

```
<script>
const app = {

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
};
</script>
```

5. Now we need to mount our component, so in main.js, we add:

```
import App from './App.vue';

createApp(App).mount('#app');
```

Here, `App` can be anything we want, but typically it is called `App`. 

6. Next in App.vue, we need to create a default export. 

```
export default {

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
}
```

The default export allows us to import the config object in App.vue when we write:

```
import App from './App.vue';
```

7. Modify the `template` section in App.vue to read

```
<template>
    <h2>Hello world!</h2>
</template>
```

After you save the file, the browser will automatically refresh. 

8. We now need to create our components. To do this, create a components directory under the src directory.

9. Create a file called `FriendContact.vue`. By creating a file with the .vue extension, Visual Studio code (with the Vetur extension enabled) can provide syntax highlighting that we've been missing all along. 

10. We're going to create a default object add add data and methods to it:

```
<script>
export default {
    data() {
        return {
            
            friend: {
                id: 'manual',
                name: 'Manuel Lorenz',
                phone: '01234 5678 991',
                email: 'manuel@localhost.com'
            },
            detailsAreVisible: false,
        };
    },

    methods: {
        toggleDetails() {
            this.detailsAreVisible = !this.detailsAreVisible;
        }
    }
};
</script>
```
11. In main.js, we then import this component.

```
import FriendContact from './components/FriendContact.vue';
...
app.component('friend-contact', FriendContact);
```

12. Next we add a template section in App.vue where we can also insert our component. 

```
<template>
    <section>
        <header><h1>My Friends</h1></header>
        <ul>
            <friend-contact></friend-contact>
            <friend-contact></friend-contact>
        </ul>
</section>
</template>
```

Where does this component appear on the page? It's going to be the first element on the page since it appears first in the template in `App.vue`.

13. For styling we can add a css file in `src/assets/style.css`.

14. Next we import the style in main.js

```
import './assets/styles.css';
```

