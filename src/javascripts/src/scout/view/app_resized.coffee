class ScoutAppResized
  resized: () ->
    project_list = $(".project_list.pane")
    list_height = $(window).height() - project_list.position().top
    list_min_width = parseInt(project_list.css("min-width"))
    list_max_width = parseInt(project_list.css("max-width"))
    list_width = project_list.outerWidth()
    wnd_width = $(window).width()
          
    if list_width > list_max_width
      list_width = list_max_width
    else if list_width < list_min_width
      list_width = list_min_width
    
    project_list.height list_height
    project_list.width list_width
    
    $("#main").css
      width: wnd_width - list_width,
      left: list_width
    
    project_item_width = $(".project .item").width()
    project_commands_width = $(".project .commands").outerWidth()
    project_source_width = project_item_width - project_commands_width
    
    if project_source_width < 0
      project_source_width = 0
    
    $(".project .source").width project_source_width
    
    false
       