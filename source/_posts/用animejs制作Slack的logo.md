title: 用 animejs 制作 Slack 的 logo
date: 2017-01-15 09:47:50
category: Frontend
tags:
  - Animation
---

[anime.js](https://github.com/juliangarnier/anime) 是一个 javascript 的动画引擎，很轻量级，只有 9kb，最开始关注它是被它[官网首页](http://anime-js.com/)的动画吸引的，感觉很有意思，最近使用 animejs，并参考这篇文章 [Building the slack animating logo with only css](http://callmenick.com/post/building-the-slack-animating-logo-with-only-css) 做了个 Slack 的 Logo 动效。

<p data-height="312" data-theme-id="0" data-slug-hash="xgEbKy" data-default-tab="result" data-user="Sanster" data-embed-version="2" data-pen-title="Slack logo made by anime.js" data-preview="true" class="codepen">See the Pen <a href="http://codepen.io/Sanster/pen/xgEbKy/">Slack logo made by anime.js</a> by Tony Chu (<a href="http://codepen.io/Sanster">@Sanster</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

可以看到，整个动画分为四个独立的球，每个球有三个动画阶段：
* 小球长度/宽度延长
* 小球长度/宽度反向减小
* 小球返回原位

使用 animejs 1.0 写出来的代码感觉不是很简洁，要用在 complete 里面嵌套着写动画，当然上面的代码还可以优化优化，不过始终有点怪怪的。作者在 2.0 里面作者增加了一个 property 可以设定多个值的支持：[Keyframes](http://anime-js.com/v2/documentation/#basicKeyframes)，和 CSS3 的 keyframe 差不多，定义每个阶段的值。2.0 中还添加了对 Synchronize animations 的支持，称为 [Timeline](http://anime-js.com/v2/documentation/#basicTimeline)，可以使用 timeline 定义要同时执行的动画，使用这两个新的特性可以写出结构更清晰的代码：

```javascript
var slack_size = '96px'
var dot_width = '18px'
var pos_dis = '78px'
var duration = 2000
var restart_wait_time = 100

var timeline = anime.timeline({
  loop: true
})

timeline.add([
  anime({
    targets: '.green',
    easing: 'linear',
    duration: duration,
    top: ['0px', pos_dis, '0px'],
    height: [slack_size, dot_width, dot_width],
  }),
  anime({
    targets: '.blue',
    easing: 'linear',
    duration: duration,
    right: ['0px', pos_dis, '0px'],
    width: [slack_size, dot_width, dot_width],
  }),
  anime({
    targets: '.pink',
    easing: 'linear',
    duration: duration,
    left: ['0px', pos_dis, '0px'],
    width: [slack_size, dot_width,dot_width],
  }),
  anime({
    targets: '.yellow',
    easing: 'linear',
    duration: duration,
    bottom: ['0px', pos_dis, '0px'],
    height: [slack_size, dot_width, dot_width],
  })
])
```
