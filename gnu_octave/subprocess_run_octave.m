function subprocess_run_octave(cmd)
% https://octave.sourceforge.io/octave/function/javaObject.html

%% DOES NOT WORK
% Octave doesn't have access to ProcessBuilder or Runtime
% error: [java] java.lang.NoSuchMethodException: java.lang.ProcessBuilder
% error: [java] java.lang.NoSuchMethodException: java.lang.Runtime

% yet if I do this from Shell, it works with the same JVM, so this must be an Octave issue
% j=/opt/homebrew/Cellar/openjdk/21/libexec/openjdk.jdk/Contents/Home/bin/
% $j/javac ProcessBuilderExample1.java
% $j/java ProcessBuilderExample1

amazon = '/Library/Java/JavaVirtualMachines/amazon-corretto-8.jdk/Contents/Home/jre/lib/server/libjvm.dylib';
homebrew = '/opt/homebrew/Cellar/openjdk/21/libexec/openjdk.jdk/Contents/Home/lib/server/libjvm.dylib';
if ismac
  jvmloc = {amazon, homebrew};
else
  jvmloc = {};
end

if isempty(getenv("JAVA_HOME"))
  for i = length(jvmloc)
    if isfile(jvmloc{i})
      setenv("JAVA_HOME", fileparts(jvmloc{i}))
      break
    end
  end
end

disp(["JAVA_HOME: " getenv("JAVA_HOME")])

% example of syntax
% buf = javaObject('java.lang.StringBuffer')

% proc = javaObject('java.lang.Runtime').getRuntime.exec();
% https://docs.oracle.com/javase/9/docs/api/java/lang/Runtime.html#getRuntime--

proc = javaObject('java.lang.ProcessBuilder');
% https://docs.oracle.com/javase/9/docs/api/java/lang/ProcessBuilder.html

proc.command(cmd);

proc.waitFor();

end
