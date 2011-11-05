class ProjectListFooterPresenter
  constructor: (@view) ->
    $(@view).bind "add_project", (event, details) ->
      ProjectModel.create details

    