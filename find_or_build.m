function exe = find_or_build(name)
arguments
  name (1,1) string
end

cwd = fullfile(fileparts(mfilename('fullpath')));

bin_dir = fullfile(cwd, "build");

exe = fullfile(bin_dir, name);

i = isfile([exe, exe + ".exe"]);
if ~any(i)
  cmake(cwd, bin_dir)
end

i = isfile([exe, exe + ".exe"]);
assert(any(i), "could not find main program")

if i(2)
  exe = exe + ".exe";
end

end
