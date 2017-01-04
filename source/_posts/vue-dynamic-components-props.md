title: vue 动态组件的参数
date: 2016-11-12 21:16:29
category: Frontend
tags: Vue2
---

Vue 提供创建 [Dynamic Components](https://vuejs.org/v2/guide/components.html#Dynamic-Components) 的能力。

示例中，一个 Vue app 有三个组件分别是 `home`、`posts` 和 `archive`：

```javascript
var vm = new Vue({
  el: '#example',
  data: {
    currentView: 'home'
  },
  components: {
    home: { /* ... */ },
    posts: { /* ... */ },
    archive: { /* ... */ }
  }
})
```

<!--more-->

在 HTML template 中可以使用 `<component>` 标签来动态指定需要渲染哪个组件，只要 `currentView` 的值改变，相应的组件就会被渲染。
```
<component v-bind:is="currentView"></component>
```

在使用动态组件的过程当中，遇到一个问题，那就是如何向「不同的组件」传递参数，我目前使用的方法是将不同组件的参数都装进一个 `options` 中：

```javascript
computed: {
    options () {
      if (this.currentView === 'home') {
        return { /* ... */ }
      } else if (this.currentView === 'posts') {
        return { /* ... */ }
      } else if (this.currentView === 'archive') {
        return { /* ... */ }
      }
    }
  }
```

这样，在使用时可以直接传递单一参数 `options`：

```
<component v-bind:is="currentView" v-bind:options="options"></component>
```

不过感觉这样以后，组件的参数传递就变得不是很清晰，必须要到组件的代码里才能知道这个组件具体使用了什么参数，不知道是否还有更优雅的方法。