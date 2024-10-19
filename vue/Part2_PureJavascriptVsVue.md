# Pure JavaScript vs. Vue

The examples in `files/part2` illustrate how Vue can simplify the process of creating a reactive web application using Vue.

If you just use pure Javascript, you (the developer) needs to address elements in order to make change in the UI. This is seen in `files/part2/gs-02-first-app-with-just-js`.

With Vue, you have the ability to work with higher-level components. For example, `files/part2/gs03-rebuilding-the-app-with-vue` introduces a Javascript file that contains the business logic and data. 

You can see how data is used more clearly in the personal example `files/part2/gs-03-tables-with-vue`. In this example, we create an object called `servers`. Vue is able to easily address each element in the index and display them in a table. This example addresses how to handle data with Vue, but as we'll see in later sections, Vue can also handily handle styling.