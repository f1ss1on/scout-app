class ScoutView
  constructor: () ->
    @app_resized = new ScoutAppResized()
    this._makeProjectListResizable()
    $(window).resize =>
      @app_resized.resized()
    
  listProjects: () -> 
    $('.projects').empty()
    Projects.all( (projects) => 
      this._listProject project for project in projects
    )

  resized: () ->
    @app_resized.resized()


  _listProject: (project) ->
    if project
      $.tmpl($("#project_template"), project).appendTo(".projects")

      if($('.project_details[data-key='+project.key+']').length == 0)
        $.tmpl($("#project_details_template"), project).appendTo("#main")
        $('.project_details[data-key='+project.key+']').find("option[data-environment=" + project.environment + "]").attr("selected", "selected")
        $('.project_details[data-key='+project.key+']').find("option[data-output_style=" + project.outputStyle + "]").attr("selected", "selected")

  _makeProjectListResizable: () ->
    resize_handles = 
      e: $('.pane.project_list .footer .splitter')
    
    $(".project_list.pane").resizable
      handles: resize_handles
      minWidth: parseInt $(".project").css("min-width")
      maxWidth: parseInt $(".project").css("max-width")
