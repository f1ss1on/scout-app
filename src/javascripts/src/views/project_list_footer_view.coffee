class ProjectListFooterView
  constructor: () ->
    @footer = $(".project_list .footer")
    @add_project_btn = @footer.find(".option.add")
    @add_project_btn.bind "click", this.addProjectByClick()
    
  addProjectByClick: () ->
    (event) =>
      ScoutUtils.createProjectBySelectingDirectory (details) =>
        $(this).trigger "add_project", details

