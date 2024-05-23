---
layout: default
title: Slides
---
# Course Slides

{% for post in site.slides %}
<a href='{{ post.url }}'>{{ post.title }}</a>
{% endfor %}
