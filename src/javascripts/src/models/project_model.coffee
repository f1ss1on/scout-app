class ProjectModel
  constructor: (@attrs) ->

  save: () ->
    defaults =
      name:"",
      projectDir:"",
      sassDir:"",
      cssDir:"",
      javascriptsDir:"",
      imagesDir:"",
      environment:"development",
      outputStyle: "expanded"

    options = $.extend defaults, @attrs;

    saveable_attrs =
      name: options.name,
      projectDir: options.projectDir,
      sassDir: options.sassDir,
      cssDir: options.cssDir,
      javascriptsDir: options.javascriptsDir,
      imagesDir: options.imagesDir,
      environment: options.environment,
      outputStyle: options.outputStyle

    Projects.save saveable_attrs, (project) =>
      $(ProjectModel).trigger("after_save", project)


ProjectModel.create = (attrs) ->
  new ProjectModel(attrs).save()
