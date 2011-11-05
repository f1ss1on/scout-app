class ProjectListPresenter
  constructor: (@view) ->
    
  appInitialized: () ->
    @view.listProjects()

  selectAndConfigure: (project) ->
    air.trace("stub: selecting and configuring project")
  