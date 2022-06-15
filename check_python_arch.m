function ok = check_python_arch()
%% check that python arch matches Matlab arch
% This can be an issues on Apple Silicon with Matlab x86 on Rosetta
% and native arm64 Python for example

ok = false;

p = pyenv;
pyexe = p.Executable;
if isempty(pyexe)
  warning("Python is not setup with Matlab. See 'help pyenv'")
  return
end

if isunix
  [ret, matlabArch] = system('uname -m');
else
  [ret, matlabArch] = system('wmic computersystem get systemtype /value');
end
if ret~=0
  warning("getting system arch failed %s", matlabArch)
  return
end

[ret, pythonArch] = system(pyexe + ' -c "import platform; print(platform.machine())"');
if ret~=0
  warning("failed to run Python %s", pythonArch)
  return
end

if isunix
  ok = isequal(pythonArch, matlabArch);
else
  if startsWith(pythonArch, "AMD64")
    ok = contains(matlabArch, "x64-based");
  elseif startsWith(pythonArch, "arm64")
    ok = contains(matlabArch, "ARM64-based");
  else
    warning("Unknown Python arch %s", pythonArch)
  end

end

end
