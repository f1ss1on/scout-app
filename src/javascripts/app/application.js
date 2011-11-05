Array.prototype.last = function() {return this[this.length-1];}

var Projects = new Lawnchair({adaptor: 'air', table: "projects"+ENV});

var app = {
  delegateTo: function(targetMethod){
    return function(evnt){
      app[targetMethod](evnt);
    };
  },

  createProjectByDroppingADirectory: function(evnt){
    evnt.preventDefault();
    directoryPath = evnt.dataTransfer.getData("text/uri-list");
    // stub
  },

  nukeAllProjects: function(){
    Projects.all(function(projects) {
      $.each(projects, function(i, project){
        if(project){
          $('.project[data-key=' + project.key + ']').remove();
          $('.project_details[data-key=' + project.key + ']').remove();
        }
      });
    });
    Projects.nuke();
    $('.projects').trigger(':changed');
    $('.projects').trigger('processes:stopAll');
    $('.project_details').hide();
    $('.non_selected').show();
  },

  viewProjectConfiguration: function() {
    $("body").removeClass("log").addClass("configuration");
    $(".project_details.selected").removeClass("log").addClass("configure").show();
  },

  viewProjectLog: function() {
    $("body").removeClass("configuration").addClass("log");
    $(".project_details.selected").removeClass("configure").addClass("log").show();
  }

};

// UI stuff
$(document).ready(function() {
  $.tmpl($('#colorize_template'));
  $.tmpl($('#project_template'));
  $.tmpl($('#project_details_template'));

  $('.content').live('drop', app.createProjectByDroppingADirectory);

  $('.project').live(':started', projectStarted);
  $('.project').live(':stopped', projectStopped);
  $('.project').live(':select', selectProject);
  $('.project').live(':select_and_configure', selectProjectConfiguration);

  $('.project_details').live(':newLogOutput', updateProjectLog);

  $('.modes .mode.configure').live('click', app.viewProjectConfiguration);
  $('.modes .mode.log').live('click', app.viewProjectLog);

  // start/stop project
  $('.project .start').live('click', startWatchingProject);
  $('.project .stop').live('click', stopWatchingProject);
  
  $('.project .name').live('dblclick', editProjectName);
  $('.project input').live('keyup', updateProjectNameByKeyUp);
  $('.project input').live('blur', updateProjectNameByLosingFocus);
  
  $('.footer .clear_log.command').live('click', clearCurrentProjectLog);
  
  function clearCurrentProjectLog(e){
    $(".project_details.selected .log_output").html("");
  }
  
  function editProjectName(e){
    $(this).data('old-name', $(this).text());
    $(this).hide();
    $(this).parents(":first").find("input:text").show().focus();
  }
  
  function saveProjectName(project_key, name){
    Projects.get(project_key, function(project) {
      project.name = name;
      Projects.save(project);
    });    
  }
  
  function updateProjectNameByKeyUp(e){
    var name,
      project_container = $(this).parents(".project:first"),
      name_container = project_container.find("a.name"),
      key = project_container.attr("data-key");
    
    if(e.which==13){ // enter key, update project name
      name = $(this).val();
      saveProjectName(key, name);
    } else if(e.which==27){ // escape key, cancel
      name = $(this).data("old-name");
    } else {
      // do nothing if it was another key code
      return;
    }

    $(this).hide();
    name_container.text(name)
    name_container.show();
  }
  
  function updateProjectNameByLosingFocus(e){
    var name = $(this).val(),
      project_container = $(this).parents(".project:first"),
      name_container = project_container.find("a.name"),
      key = project_container.attr("data-key");

    saveProjectName(key, name);
    $(this).hide();
    name_container.text(name);
    name_container.show();
  }
  
  $('.select_sass_dir').live('click', selectSassDirBySelectingDirectory);
  $('.select_css_dir').live('click', selectCssDirBySelectingDirectory);
  $('.select_javascripts_dir').live('click', selectJavascriptsDirBySelectingDirectory);
  $('.select_images_dir').live('click', selectImagesDirBySelectingDirectory);
  $('.select_environment').live('change', selectEnvironment);
  $('.select_output_style').live('change', selectOutputStyle);
  $('.project_details .delete').live('click', deleteProject);

  $('.project .item').live('click', function() {
    var key = $(this).parents('.project:first').attr('data-key');
    $('.project[data-key='+key+']').trigger(':select');
  });
  
  $('#nuke').live('click', app.delegateTo('nukeAllProjects'));
  
  function updateProjectLog(evnt, data) {
    var key = $(this).attr('data-key');
    
    // Temporary filter to strip out FSSM recommendations to install an optimized
    // version of fsevents. It is OSX compatible but not JRuby compatible. At this point
    // it's just noise.
    data = data.replace(/^FSSM\s.*\n/mg, '');
    
    $('.project_details.selected .log_output').append(colorize(data.replace("\n", "<br />")));
  }

  function selectProject() {
    $('.project').removeClass('selected');
    $(this).addClass('selected');

    $('.project_details').removeClass('selected');
    $('.project_details[data-key='+$(this).data('key')+']').addClass('selected');
  }

  function selectProjectConfiguration(){
    $(this).trigger(":select");
    app.viewProjectConfiguration();
  }

  var colors = {
    "33": "yellow",
    "32": "green",
    "31": "red",
    "0": ""
  }

  function colorize(string) {
    new_string = string.replace(/\033\[(\d+)m([^\033]+)\033\[0m/g, function(match, color, string, offset, original) {
      thing = $.tmpl($('#colorize_template'),  { color: colors[color], string: string }).html();
      return thing;
    });
    return new_string.replace(/\033\[(\d+)m/g, '');
  }

  function startWatchingProject() {
    var project_container = $(this).parents('.project:first');
    key = project_container.attr('data-key');
    Projects.get(key, function(project) {
      setProjectState(project_container, "starting");
      project_container.trigger("watch:start", { project: project });
    });
    $('.project[data-key='+key+']').trigger(':select');
    app.viewProjectLog();
    return false;
  }

  function stopWatchingProject(){
    var project_container = $(this).parents('.project:first');
    key = project_container.attr('data-key');
    Projects.get(key, function(project) {
      setProjectState(project_container, "stopping");
      project_container.trigger("watch:stop", { project: project });
    });
    return false;
  }

  function setProjectState(project, state){
    $(project).removeClass("starting")
      .removeClass("stopping")
      .removeClass("started")
      .removeClass("stopped")
      .addClass(state);
  };

  function projectStopped() {
    setProjectState(this, "stopped");
  }

  function projectStarted() {
    setProjectState(this, "started");
  }

  new ScoutApp().initialize();
});


function deleteProject() {
  key = $(this).parents('.project_details:first').attr('data-key');
  Projects.get(key, function(project) {
    Projects.remove(project);
  });
  $('.project[data-key='+key+']:first').trigger('watch:stop');
  $('.projects').trigger(':changed');

  $('.project_details').hide();
  $('.non_selected').show();

  return false;
}

function selectCssDirBySelectingDirectory() {
  key = $(this).parents('.project_details:first').attr('data-key');
  Projects.get(key, function(project) {
    browseDirectories(project.projectDir, function(evnt){
      project.cssDir = evnt.target.nativePath;
      Projects.save(project);
      $('.project_details[data-key='+key+'] .css_dir').val(evnt.target.nativePath);
    });
  });
  return false;
}

function selectSassDirBySelectingDirectory() {
  key = $(this).parents('.project_details:first').attr('data-key');
  Projects.get(key, function(project) {
    browseDirectories(project.projectDir, function(evnt){
      project.sassDir = evnt.target.nativePath;
      Projects.save(project);
      $('.project_details[data-key='+key+'] .sass_dir').val(evnt.target.nativePath);
    });
  });
  return false;
}

function selectJavascriptsDirBySelectingDirectory() {
  key = $(this).parents('.project_details:first').attr('data-key');
  Projects.get(key, function(project) {
    browseDirectories(project.projectDir, function(evnt){
      project.javascriptsDir = evnt.target.nativePath;
      Projects.save(project);
      $('.project_details[data-key='+key+'] .javascripts_dir').val(evnt.target.nativePath);
    });
  });
  return false;
}

function selectImagesDirBySelectingDirectory() {
  key = $(this).parents('.project_details:first').attr('data-key');
  Projects.get(key, function(project) {
    browseDirectories(project.projectDir, function(evnt){
      project.imagesDir = evnt.target.nativePath;
      Projects.save(project);
      $('.project_details[data-key='+key+'] .images_dir').val(evnt.target.nativePath);
    });
  });
  return false;
}

function selectEnvironment() {
  var project_details = $(this).parents('.project_details:first');
  var key = project_details.attr('data-key');
  Projects.get(key, function(project) {
    var environment = $(project_details).find('select.select_environment option:selected').attr('data-environment');
    project.environment = environment;
    Projects.save(project);
  });

  return false;
}

function selectOutputStyle() {
  var project_details = $(this).parents('.project_details:first');
  var key = project_details.attr('data-key');
  Projects.get(key, function(project) {
    var output_style = $(project_details).find('select.select_output_style option:selected').attr('data-output_style');
    project.outputStyle = output_style;
    Projects.save(project);
  });

  return false;
}

function browseDirectories(initialPath, callback) {
  var directory = new air.File(initialPath);
  try
  {
    directory.browseForDirectory("Select Directory");
    directory.addEventListener(air.Event.SELECT, callback);
  }
  catch (error)
  {
    air.trace("Failed:", error.message)
  }
}
