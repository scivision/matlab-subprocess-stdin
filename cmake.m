function cmake(src_dir, build_dir)
% build program using CMake and default generator
% specify CMake generator: set environment variable CMAKE_GENERATOR
arguments
  src_dir (1,1) string {mustBeFolder}
  build_dir (1,1) string
end

% Recommend absolute path, as Unix-like cannot traverse upwards from non-existent dir.
% build_dir needs absolute as well or CMake will use pwd instead
% see Matlab-stdlib posix and absolute_path for solution.

mustBeFile(fullfile(src_dir, "CMakeLists.txt"))

[ret, ~] = system("cmake --version");
if ret ~= 0
  macos_path()
  assert(system("cmake --version") == 0, "CMake not found")
end

%% configure
cmd = "cmake -S" + src_dir + " -B" + build_dir;
assert(system(cmd) == 0, "error configuring %s with CMake", src_dir)

%% build
cmd = "cmake --build " + build_dir + " --parallel";

assert(system(cmd) == 0, 'error building with CMake in %s', build_dir)

end % function
