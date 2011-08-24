class ProjectMainView
  resize: () ->
    $("#main").css
      width: $(window).width() - $(".project_list").width(),
      left: $(".project_list").width()

