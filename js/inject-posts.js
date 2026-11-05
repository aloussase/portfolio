window.addEventListener('load', () => {
  app.ports.injectBlogPost.subscribe(function(contents) {
    setTimeout(() => {
      const el = document.getElementById("blog-post");
      el.innerHTML = contents;
    }, 1000)
  });
})
