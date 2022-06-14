function exe = find_exe(name)
arguments
  name (1,1) string {mustBeNonzeroLengthText}
end

cwd = fullfile(fileparts(mfilename('fullpath')));

if ispc && ~endsWith(name, ".exe")
  name = name + ".exe";
end

for d = [cwd, fullfile(cwd, "build")]
  exe = fullfile(d, name);
  if isfile(exe)
    return
  end
end

exe = string.empty;

end
