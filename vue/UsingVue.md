# Using Vue

## Introduction

This section is based on https://www.vuemastery.com/courses/real-world-vue3/vue-cli-creating-the-project.

## Creating a Project using the CLI

After installing vue, run the following command to create a vue project.

```
vue create <project name>
```

For example:

```
vue create real-world-vue
```

This will display an interactive menu.

```
$ vue create real-world-vue


Vue CLI v5.0.8
? Please pick a preset: 
  Default ([Vue 3] babel, eslint) 
  Default ([Vue 2] babel, eslint) 
❯ Manually select features 
```

Select `Manually select features` and then `Babel` and `Vuex`. Hit enter and choose the version of vue.

```
Vue CLI v5.0.8
? Please pick a preset: Manually select features
? Check the features needed for your project: Babel, Router, Vuex
? Choose a version of Vue.js that you want to start the project with (Use arrow keys)
❯ 3.x 
  2.x
```

Select 3.x then `Y` to choose `history mode` for router.

Choose to place config files in `dedicated config files` (the default).

When it's done, vue gives you two comands to run:

```
$ cd real-world-vue
$ npm run serve
```

Afterwards, you should be able to reach your application at `http://localhost:8080`. 

You can spin up vue ui to manage vue projects on your localhost.

```
vue ui
```

Afterwards navigate to `http://localhost:8080`.

The vue ui can do everything that the CLI can, and more in an intuitive manner! 

For example, you can install the `vue-cli-plugin-vuetify` plugin for the existing project. YOu should be able to do this from the command-line, but the UI simplifies this task.

## How Vue3 works

Go to the project directory of real-world-vue.

- App.vue is the root component in which all of our application code is nested. 
- main.js takes all of our application code and creates are app, mounting it to the DOM, specifically in the DIV in index.html. with the ID of app.


## References

- https://www.vuemastery.com/

- https://vuejs.org/guide/quick-start.html#creating-a-vue-application