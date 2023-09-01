function ok = check_python_arch()
%% check that python arch matches Matlab arch
% This can be an issues on Apple Silicon with Matlab x86 on Rosetta
% and native arm64 Python for example

matlabArch = lower(string(java.lang.System.getProperty("os.arch")));

pythonArch = lower(string(py.platform.machine()));

ok = isequal(pythonArch, matlabArch);
if ~ok
  switch pythonArch
    case "arm64", ok = contains(matlabArch, "aarch64");
    case "aarch64", ok = contains(matlabArch, "arm64");
    otherwise, warning("Unknown Python arch %s", pythonArch)
  end
end

end
