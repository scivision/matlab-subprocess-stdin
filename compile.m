function bin = compile(src)
%% compile single source file (C, C++, Fortran)
% tries to use mex compiler, falls back to generic GCC-like compiler
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
    if isempty(c)
      cc = "c++";
    end
  case ".c"
    c = mex.getCompilerConfigurations('c');
    if isempty(c)
      cc = "cc";
    end
  case {".f", ".F", ".f90", ".F90"}
    c = mex.getCompilerConfigurations('fortran');
    if isempty(c)
      cc = "gfortran";
    end
  otherwise
    error("unhandled source type " + src_ext)
end

msvcLike = false;
shell = '';
extraFlag = "";
outFlag = "-o";

if(~isempty(c))
  cc = c.Details.CompilerExecutable;
  if ispc
    msvcLike = endsWith(cc, "cl");
  end
  shell = strtrim(c.Details.CommandLineShell);
  shell_arg = c.Details.CommandLineShellArg;

  if msvcLike
    shell = append('"', shell, '"');
    extraFlag = append("/EHsc /Fo", tempdir);
    outFlag = "/link /out:";
  end
end

cmd = append(cc, " ", extraFlag, " ", src, " ", outFlag, bin);
if(~isempty(shell))
  cmd = append(shell, " ", shell_arg, " && ", cmd);
end

disp(cmd)

[ret, msg] = system(cmd);

assert(ret==0, "failed to compile %s:   %s", bin, msg)

end
