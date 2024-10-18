# An Alternative Method: Using Vue from CDN

An alternative way to use Vue is by using a script tag. Simply add the following in an HTML file before you include a Javascript file. This is done in files/vue-project.

```
<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
```

In files/vue-project/app.js, we add the global Vue object called `Vue`. In this Vue object we call createApp() and pass in an object which contains a property called `data`.

```javascript
Vue.createApp({
  data: function () {},
});
```

In modern Javascript, we can also call it like this:

```javascript
Vue.createApp({
  data() {},
});
```

The craeteApp object take data and methods that operate on its data. We must mount the object onto a div which in this case is `#app`.

One suggestion to improve the coding experience is to intall the `prettier` extension to help auto-format Javascript files. After installing the extension, go to Extensions and search for Format, and set the default formatter to prettier. Next, go to View -> Command Palette and search for Format Document and add a shortcut like Ctr-Shfit -f.
