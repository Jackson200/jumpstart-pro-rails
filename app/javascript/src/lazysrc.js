// Lazily loads elements with a data-src attribute.
// This is useful for speeding up initial page rendering.
//
// <img data-src="/assets/img.png" />
// <iframe data-src="https://youtube.com"></iframe>

document.addEventListener("turbo:load", () => {
  document.querySelectorAll('[data-src]').forEach((element) =>{
    element.setAttribute('src', element.getAttribute('data-src'))
  })
})
