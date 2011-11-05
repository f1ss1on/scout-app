ScoutUtils = {}

ScoutUtils.browseForDirectory = (initial_path, callback) ->
  dir = new air.File(initial_path)
  try
    dir.browseForDirectory "Select Directory"
    dir.addEventListener air.Event.SELECT, callback
  catch err
    air.trace "Failed", err.message

ScoutUtils.createProjectBySelectingDirectory = (callback) ->
  ScoutUtils.browseForDirectory air.File.userDirectory.nativePath, (event) ->
    callback ScoutUtils.osIndependentDetailsForFileEvent(event)

ScoutUtils.osIndependentDetailsForFileEvent = (event) ->
  if(air.Capabilities.os.match(/Windows/))
    name: event.target.nativePath.replace(/\\$/, '').split('\\').last(),
    projectDir: event.target.nativePath
  else
    name: event.target.nativePath.replace(/\/$/, '').split('/').last(),
    projectDir: event.target.nativePath

ScoutUtils.projectSelector = (project) ->
  '.project[data-key=' + project.key + ']'

ScoutUtils.projectDetailsSelector = (project) ->
  '.project_details[data-key=' + project.key + ']'

