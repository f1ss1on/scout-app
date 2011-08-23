Processes = {}

class JavaRuntime
  absolute_path: () -> 
    if(air.Capabilities.os.match(/Windows/))
      air.File.applicationDirectory.resolvePath("C:\\Program Files\\Java\\jre6\\bin\\java.exe")
    else
      air.File.applicationDirectory.resolvePath("/usr/bin/java")

class CompassRuntime
  absolute_path: () ->
    air.File.applicationDirectory.resolvePath('bin/compass').nativePath


class ProjectWatcher
  constructor: (@data, @java_runtime = new JavaRuntime(), @compass_runtime = new CompassRuntime()) ->

  watch: () ->
    this.start_native_process()
    
  stop: () ->
    this.stop_native_process()

  start_native_process: () ->
     @process = new air.NativeProcess()
     @process.addEventListener air.ProgressEvent.STANDARD_OUTPUT_DATA, this.output_data_handler()
     @process.addEventListener air.ProgressEvent.STANDARD_ERROR_DATA, this.error_data_handler()
     @process.addEventListener air.NativeProcessExitEvent.EXIT, this.on_exit()
     @process.start this.startup_info()
     $('.project[data-key=' + @data.project.key + ']').trigger ':started'

  startup_info: () ->
    @startup_info = new air.NativeProcessStartupInfo
    @startup_info.arguments = this.process_args()
    @startup_info.executable = @java_runtime.absolute_path()
    @startup_info

  process_args: () ->
    args = new air.Vector["<String>"]()
    args.push(
      '-jar', air.File.applicationDirectory.resolvePath('vendor/jruby-complete.jar').nativePath,
      '-S',
      @compass_runtime.absolute_path(),
      "watch",
      '--require', 'ninesixty',
      '--require', 'yui',
      "--sass-dir", @data.project.sassDir,
      "--css-dir", @data.project.cssDir,
      "--images-dir", @data.project.imagesDir,
      "--javascripts-dir", @data.project.javascriptsDir,
      "--environment", @data.project.environment,
      "--output-style", @data.project.outputStyle,
      "--trace"    
    )
    args

  stop_native_process: () ->
    @process.exit();
    $('.project[data-key=' + @data.project.key + ']').trigger ':stopped'

  error_data_handler: () ->
    (event) =>
      bytes = @process.standardError.readUTFBytes @process.standardError.bytesAvailable
      $('.project_details[data-key=' + @data.project.key + ']').trigger ':newLogOutput', bytes.toString();

  output_data_handler: () ->
    (event) =>
      bytes = @process.standardOutput.readUTFBytes @process.standardOutput.bytesAvailable
      $('.project_details[data-key=' + @data.project.key + ']').trigger ':newLogOutput', bytes.toString()

  on_exit: () ->
    (event) =>
      $('.project[data-key=' + @data.project.key + ']').trigger 'watch:stop';


startWatchingProject = (event, data) ->
  Processes[$(this)] = watcher = new ProjectWatcher(data)
  watcher.watch()

stopWatchingProject = (event, data) ->
  Processes[$(this)].stop()

stopAllWatchers = (event, data) ->
  watcher.stop() for project, watcher of Processes

$(".project").live "watch:start", startWatchingProject
$(".project").live "watch:stop", stopWatchingProject
$(".projects").live "processes:stopAll", stopAllWatchers

air.NativeApplication.nativeApplication.addEventListener air.Event.EXITING, stopAllWatchers
window.nativeWindow.addEventListener air.Event.CLOSING, stopAllWatchers
