title: css-position
date: 2016-08-14 09:18:19
category: CSS
tags:
---

CSS 中和元素位置相关的属性有：display

# display 属性
* block：div 的默认属性，占据 100% 的宽度，两边不能有其它元素
* inline-block：允许其他元素置于旁边，The inline-block value allows you to put several block elements on the same line.
* inline：允许几个元素处于同一行上，每个元素仅占据元素所需的宽度，设为 inline 的元素不会保持他们的尺寸The inline value places all your elements next to one another, but not as blocks: they don't keep their dimensions.
* none：隐藏元素

The good news is, inline places all your elements on a single line. The bad news is that it doesn't maintain their "box"ness: as you saw, all your <div>s got squished to the smallest possible width!

The inline display value is better suited for HTML elements that are blocks by default, such as headers and paragraphs.

The margin is the space around the element. The larger the margin, the more space between our element and the elements around it. We can adjust the margin to move our HTML elements closer to or farther from each other.

The border is the edge of the element. It's what we've been making visible every time we set the border property.

The padding is the spacing between the content and the border. We can adjust this value with CSS to move the border closer to or farther from the content.

The content is the actual "stuff" in the box. If we're talking about a <p> element, the "stuff" is the text of the paragraph.

For instance, if we take an HTML element with a specific width (such as our <div> in the editor) and set its margin to auto, this tells the document to automatically put equal left and right margins on our element, centering it on the page.

# Float
One way is to use floats. When you float an element on the page, you're telling the webpage: "I'm about to tell you where to put this element, but you have to put it into the flow of other elements." This means that if you have several elements all floating, they all know the others are there and don't land on top of each other.

float: right;left

Unfortunately, we sometimes mix large floating elements with non-floating ones, and elements do end up on top of each other.

See your footer (the blue bit between the two columns)? It's stuck back there because we haven't told it something very important: to clear the other elements on the page!

If you tell an element to clear: left, it will immediately move below any floating elements on the left side of the page; it can also clear elements on the right. If you tell it to clear: both, it will get out of the way of elements floating on the left and right!

# position
The first type of positioning is absolute positioning. When an element is set to position: absolute, it's then positioned in relation to the first parent element it has that doesn't have position: static. If there's no such element, the element with position: absolute gets positioned relative to <html>.

left right 作用

Relative positioning is more straightforward: it tells the element to move relative to where it would have landed if it just had the default static positioning.