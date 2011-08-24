class ScoutApp
  constructor: () ->
    @project_list_view = new ProjectListView()
    @project_list_presenter = new ProjectListPresenter(@project_list_view)
    
    @project_main_view = new ProjectMainView()
    
    @window = new AppWindow $(window), @project_list_view, @project_main_view
      
  initialize: () ->
    @project_list_presenter.appInitialized();
    @window.appInitialized()
