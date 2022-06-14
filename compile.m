function bin = compile(src)
%% compile single source file (C, C++, Fortran)
arguments (Input)
  src (1,1) string {mustBeFile}
end
arguments (Output)
  bin (1,1) string {mustBeFile}
end

[~,src_name, src_ext] = fileparts(src);

bin = src_name;
if ispc
  bin = append(bin, ".exe");
end

switch src_ext
  case {".cpp", ".cxx"}
    c = mex.getCompilerConfigurations('c++');
  case ".c"
    c = mex.getCompilerConfigurations('c');
  case {".f", ".F", ".f90", ".F90"}
    c = mex.getCompilerConfigurations('fortran');
  otherwise
    error("unhandled source type " + src_ext)
end

cc = c.Details.CompilerExecutable;
msvcLike = false;
if ispc
  msvcLike = endsWith(cc, "cl");
end
shell = strtrim(c.Details.CommandLineShell);
shell_arg = c.Details.CommandLineShellArg;

if msvcLike
  shell = append('"', shell, '"');
  extraFlag = append("/EHsc /Fo", tempdir);
  outFlag = "/link /out:";
else
  extraFlag = "";
  outFlag = "-o";
end

cmd = append(cc, " ", extraFlag, " ", src, " ", outFlag, bin);
if(~isempty(shell))
  cmd = append(shell, " ", shell_arg, " && ", cmd);
end

disp(cmd)

[ret, msg] = system(cmd);

assert(ret==0, "failed to compile %s:   %s", bin, msg)

end
