class JavaRuntime
  absolute_path: () -> 
    if(air.Capabilities.os.match(/Windows/))
      air.File.applicationDirectory.resolvePath("C:\\Program Files\\Java\\jre6\\bin\\java.exe")
    else
      air.File.applicationDirectory.resolvePath("/usr/bin/java")


