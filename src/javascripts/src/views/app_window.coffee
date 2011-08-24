class AppWindow
  constructor: (@window, @list_view, @main_view) ->
  
  appInitialized: () ->
    @window.resize =>
      this.resize()
  
  resize: () ->
    @list_view.resize()
    @main_view.resize()
       