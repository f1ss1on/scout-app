class ScoutPresenter
  constructor: (@view) ->
    
  appInitialized: () ->
    @view.listProjects()
    @view.resized()
    #@view.initialize()
    
  
  