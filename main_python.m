function main_python(a,b)
%% demo adding two number via Fortran executable called by Python
narginchk(2,2)
validateattributes(a, {'numeric'}, {'scalar'}, 1)
validateattributes(b, {'numeric'}, {'scalar'}, 2)

cwd = fullfile(fileparts(mfilename('fullpath')));

%% create command line
exe = fullfile(cwd, 'main.exe');
build('main.f90', exe)

%% assemble stdin
% notice that the last character is a newline.
in_stream = sprintf('%f %f\n', a, b);

%% run via Python
ret = py.subprocess.check_output(exe, pyargs('input', in_stream, 'text', true, 'timeout', 5));
% this raises Matlab error if executable fails
%% parse output
ab_sum = cell2mat(textscan(char(ret), '%f', 'CollectOutput', true));

fprintf('%f + %f = %f\n', a, b, ab_sum)

end
