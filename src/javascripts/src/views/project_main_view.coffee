class ProjectMainView
  constructor: () ->
    @main = $("#main")
  
  resize: () ->
    @main.css
      width: $(window).width() - $(".project_list").width(),
      left: $(".project_list").width()

  select: (project) ->
    @main.find('.project_details').removeClass 'selected'
    @main.find(ScoutUtils.projectDetailsSelector(project)).addClass 'selected'
    

