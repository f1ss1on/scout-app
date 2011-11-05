class ScoutApp
  constructor: () ->
    @project_list_footer_view = new ProjectListFooterView()
    @project_list_footer_presenter = new ProjectListFooterPresenter @project_list_footer_view
    
    @project_list_view = new ProjectListView()
    @project_list_presenter = new ProjectListPresenter @project_list_view
    
    @project_main_view = new ProjectMainView()

    @scout_app_presenter = new ScoutAppPresenter @project_list_view, @project_main_view
    
    @window = new AppWindow $(window), @project_list_view, @project_main_view
    
  initialize: () ->
    @project_list_presenter.appInitialized()
    @window.appInitialized()


