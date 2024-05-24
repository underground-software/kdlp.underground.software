---
layout: default
title: Articles
---
# Articles

{% for post in site.articles %}
<a href='{{ post.url }}'>{{ post.title }}</a>
{% endfor %}
