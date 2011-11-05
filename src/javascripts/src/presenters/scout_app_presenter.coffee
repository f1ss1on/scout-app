class ScoutAppPresenter
  constructor: (@project_list, @project_main) ->
    $(ProjectModel).bind "after_save", (event, project) =>
      @project_list.listProjects()
      this.selectAndConfigure project

  selectAndConfigure: (project) ->
    @project_list.select project
    @project_main.select project

  