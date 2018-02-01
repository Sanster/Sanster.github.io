{% extends '_layout.swig' %}
{% import '_macro/sidebar.swig' as sidebar_template %}

{% block title %} {{ __('title.archive') }} | {{ config.title }} {% endblock %}

{% block page_class %} page-archive {% endblock %}

{% block content %}

  <section id="posts" class="posts-collapse">
    {% for post in site.posts.sort('-date') %}
      <div class="archive-post-row">
        <h1 class="archive-post-title" itemprop="name headline">
          <a class="post-title-link" href="{{ url_for(post.path) }}" itemprop="url">
            {{ post.title | default(__('post.untitled'))}}
          </a>
        </h1>
        <time title="{{ __('post.created') }}" itemprop="dateCreated datePublished" datetime="{{ moment(post.date).format() }}">
          {{ date(post.date, config.date_format) }}
        </time>
      </div>
    {% endfor %}

  </section>

{% endblock %}

{% block sidebar %}
  {{ sidebar_template.render(false) }}
{% endblock %}
