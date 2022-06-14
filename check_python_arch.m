function ok = check_python_arch()
%% check that python arch matches Matlab arch
% This can be an issues on Apple Silicon with Matlab x86 on Rosetta
% and native arm64 Python for example

ok = true;

if ~isunix
  % for Unix-like systems only at this time. As Windows ARM gets more
  % popular may investigate
  return
end

[ret, matlabArch] = system('uname -m');
assert(ret==0, "uname failed %s", matlabArch)

p = pyenv;
pyexe = p.Executable;
if isempty(pyexe)
  error("Python is not setup with Matlab. See 'help pyenv'")
end

[ret, pythonArch] = system(pyexe + ' -c "import platform; print(platform.machine())"');
assert(ret==0, "failed to run Python %s", pythonArch)

ok = isequal(pythonArch, matlabArch);

end