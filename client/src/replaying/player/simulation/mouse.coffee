class Mouse
  constructor: (@document, container) ->
    @initUI(container)

  setPosition: (x, y) ->
    @ui.pointer.style.left = "#{x}px"
    @ui.pointer.style.top = "#{y}px"
    @ui.pointer.style.display = "block"

  mouseOut: ->
    @ui.pointer.style.display = "none"

  addClick: (x, y) ->
    click = @document.createElement("div")
    click.addEventListener("webkitAnimationEnd", =>
      @ui.clicksContainer.removeChild(click)
    )
    click.style.left = "#{x}px"
    click.style.top = "#{y}px"
    click.classList.add("click")
    @ui.clicksContainer.appendChild(click)

  initUI: (container) ->
    @ui = {
      mouseContainer: @document.createElement("div")
      pointer: @document.createElement("div")
      clicksContainer: @document.createElement("div")
    }
    pointerImage = @document.createElement("img")
    pointerImage.src = "/mouse_icon.svg"
    pointerImage.setAttribute("width", "12px")
    pointerImage.setAttribute("height", "20px")
    @ui.pointer.appendChild(pointerImage)
    @ui.pointer.classList.add("pointer")
    @ui.clicksContainer.classList.add("clicks_container")
    @ui.mouseContainer.classList.add("mouse_container")
    @ui.mouseContainer.appendChild(@ui.clicksContainer)
    @ui.mouseContainer.appendChild(@ui.pointer)
    container.appendChild(@ui.mouseContainer)

module.exports = Mouse
