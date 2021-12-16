function ab_sum = main_python(a,b)
%% demo adding two number via Fortran executable called by Python
arguments
  a (1,1) {mustBeNumeric}
  b (1,1) {mustBeNumeric}
end

cwd = fullfile(fileparts(mfilename('fullpath')));

%% create command line
bin_dir = fullfile(cwd, "build");
exe = fullfile(bin_dir, "main");
if ~any(isfile([exe, exe + ".exe"]))
  cmake(cwd, bin_dir)
end
%% assemble stdin
% notice that the last character is a newline.
in_stream = sprintf('%f %f\n', a, b);

%% run via Python
ret = py.subprocess.check_output(exe, pyargs('input', in_stream, 'text', true, 'timeout', 5));
% this raises Matlab error if executable fails
%% parse output
ab_sum = cell2mat(textscan(char(ret), '%f', 'CollectOutput', true));
end
