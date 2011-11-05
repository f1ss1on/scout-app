class ProjectListView
  constructor: () ->
    this._makeResizable()
    @list = $(".project_list")
    $('.projects').live ":changed", (event) =>
      this.listProjects()
  
  listProjects: () -> 
    $('.projects').empty()
    Projects.all (projects) => 
      this._listProject project for project in projects

  resize: () ->
    this._resizeList()
    this._resizeItems()
    
  select: (project) ->
    @list.find('.project').removeClass('selected')
    @list.find(ScoutUtils.projectSelector(project)).addClass 'selected'

  _resizeList: () ->
    height = this._listHeight()
    width = this._listWidth()
    max_width = this._maxWidth()
    min_width = this._minWidth()
    wnd_width = $(window).width()
    
    width = max_width if width > max_width
    width = min_width if width < min_width
    
    @list.css
      height: height
      width: width

  _resizeItems: () ->
    item_width = $(".project .item").width()
    commands_width = $(".project .commands").outerWidth()
    width = item_width - commands_width
    width = 0 if width < 0
    $(".project .source").width width
    
  _maxWidth: () ->
    parseInt @list.css("max-width")

  _minWidth: () ->
    parseInt @list.css("min-width")
  
  _listWidth: () ->
    @list.outerWidth()
  
  _listHeight: () ->
    $(window).height() - @list.position().top

  _listProject: (project) ->
    if project
      $.tmpl($("#project_template"), project).appendTo(".projects")

      if($('.project_details[data-key='+project.key+']').length == 0)
        $.tmpl($("#project_details_template"), project).appendTo("#main")
        $('.project_details[data-key='+project.key+']').find("option[data-environment=" + project.environment + "]").attr("selected", "selected")
        $('.project_details[data-key='+project.key+']').find("option[data-output_style=" + project.outputStyle + "]").attr("selected", "selected")

  _makeResizable: () ->
    resize_handles = 
      e: $('.pane.project_list .footer .splitter')
    
    $(".project_list.pane").resizable
      handles: resize_handles
      minWidth: parseInt $(".project").css("min-width")
      maxWidth: parseInt $(".project").css("max-width")
