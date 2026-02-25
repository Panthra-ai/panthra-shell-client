---
layout: default
title: "Panthra Shell Client Blog"
description: "Professional shell client for Panthra trading API - Tutorials, updates, and best practices for automated trading."
seo:
  type: WebPage
---

<div class="hero-section">
    <div class="hero-content">
        <h1>Panthra Shell Client Blog</h1>
        <p class="hero-description">
            Professional shell client for the Panthra trading API. 
            Tutorials, updates, and best practices for automated trading.
        </p>
        <div class="hero-actions">
            <a href="https://github.com/Panthra-ai/panthra-shell-client" class="cta-button primary">
                <img src="{{ '/assets/images/github-icon.svg' | relative_url }}" alt="GitHub">
                Get Started
            </a>
            <a href="{{ '/blog/' | relative_url }}" class="cta-button secondary">
                Read Blog Posts
            </a>
        </div>
    </div>
</div>

<section class="features-section">
    <div class="container">
        <h2>Why Choose Panthra Shell Client?</h2>
        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon">🌍</div>
                <h3>Cross-Platform</h3>
                <p>Works on Linux, macOS, and Windows with universal shell support</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">⚡</div>
                <h3>One-Liner Install</h3>
                <p>Get started in seconds with our simple installation script</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🔒</div>
                <h3>Secure</h3>
                <p>Enterprise-grade security with encrypted credential storage</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">📊</div>
                <h3>Professional</h3>
                <p>Production-ready tools for serious trading automation</p>
            </div>
        </div>
    </div>
</section>

<section class="latest-posts-section">
    <div class="container">
        <h2>Latest Blog Posts</h2>
        <div class="posts-grid">
            {% for post in site.posts limit:3 %}
            <article class="post-card">
                {% if post.image %}
                <div class="post-card-image">
                    <img src="{{ post.image | relative_url }}" alt="{{ post.title }}">
                </div>
                {% endif %}
                <div class="post-card-content">
                    <div class="post-meta">
                        <time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %d, %Y" }}</time>
                        {% if post.categories %}
                        <span class="post-category">{{ post.categories | first }}</span>
                        {% endif %}
                    </div>
                    <h3><a href="{{ post.url | relative_url }}">{{ post.title }}</a></h3>
                    <p>{{ post.description }}</p>
                    <a href="{{ post.url | relative_url }}" class="read-more">Read More →</a>
                </div>
            </article>
            {% endfor %}
        </div>
        <div class="view-all-posts">
            <a href="{{ '/blog/' | relative_url }}" class="cta-button secondary">View All Posts</a>
        </div>
    </div>
</section>

<section class="quick-start-section">
    <div class="container">
        <h2>Quick Start Guide</h2>
        <div class="quick-steps">
            <div class="step">
                <div class="step-number">1</div>
                <div class="step-content">
                    <h3>Install</h3>
                    <pre><code>curl -sSL https://raw.githubusercontent.com/Panthra-ai/panthra-shell-client/main/install-remote.sh | bash</code></pre>
                </div>
            </div>
            <div class="step">
                <div class="step-number">2</div>
                <div class="step-content">
                    <h3>Configure</h3>
                    <pre><code>source ~/.profile
panthra configure</code></pre>
                </div>
            </div>
            <div class="step">
                <div class="step-number">3</div>
                <div class="step-content">
                    <h3>Start Trading</h3>
                    <pre><code>panthra orders list
panthra positions open</code></pre>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="resources-section">
    <div class="container">
        <h2>Resources & Links</h2>
        <div class="resources-grid">
            <div class="resource-card">
                <h3>📖 Documentation</h3>
                <p>Complete API reference and usage examples</p>
                <a href="https://panthra.ai/documentation/clients-panthra-shell-client" class="resource-link">View Docs →</a>
            </div>
            <div class="resource-card">
                <h3>🌐 Panthra Platform</h3>
                <p>Advanced trading platform and analytics</p>
                <a href="https://panthra.ai" class="resource-link">Visit Platform →</a>
            </div>
            <div class="resource-card">
                <h3>💻 GitHub</h3>
                <p>Source code, issues, and contributions</p>
                <a href="https://github.com/Panthra-ai/panthra-shell-client" class="resource-link">View on GitHub →</a>
            </div>
            <div class="resource-card">
                <h3>📧 Support</h3>
                <p>Get help from our support team</p>
                <a href="https://panthra.ai/support" class="resource-link">Contact Support →</a>
            </div>
        </div>
    </div>
</section>
