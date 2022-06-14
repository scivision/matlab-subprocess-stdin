function compile(src, bin)
%% compile C++ source file
arguments (Input)
  src (1,1) string {mustBeFile}
  bin (1,1) string
end

[d,s,e] = fileparts(src);
[~,~,ext] = fileparts(bin);

switch e
  case {".cpp", ".cxx"}
    cpp = mex.getCompilerConfigurations('c++');
    cxx = cpp.Details.CompilerExecutable;
    if ispc
      msvcLike = endsWith(cxx, "cl");
      if ext ~= ".exe"
        bin = append(bin, ".exe");
      end
    else
      msvcLike = false;
    end
  otherwise
    error("unhandled source type " + e)
end

if msvcLike
  extraFlag = "/EHsc";
  outFlag = "/out:";
else
  extraFlag = string.empty;
  outFlag = "-o";
end

cmd = append(cxx, " ", extraFlag, " ", src, " /link ", outFlag, bin);
if(~isempty(cpp.Details.CommandLineShell))
  cmd = append('"', strtrim(cpp.Details.CommandLineShell), '"', " ", cpp.Details.CommandLineShellArg, " && ", cmd);
end

disp(cmd)

system(cmd)

end
