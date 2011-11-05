class ProjectListPresenter
  constructor: (@view) ->
    
  appInitialized: () ->
    @view.listProjects()

  selectAndConfigure: (project) ->
    air.trace("selecting and configuring project")
  