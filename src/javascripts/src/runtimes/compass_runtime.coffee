class CompassRuntime
  absolute_path: () ->
    air.File.applicationDirectory.resolvePath('bin/compass').nativePath

