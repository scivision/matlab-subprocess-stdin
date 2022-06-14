function ab_sum = main_python(a,b)
%% demo adding two number via Fortran executable called by Python
arguments
  a (1,1) {mustBeReal}
  b (1,1) {mustBeReal}
end

exe = find_exe("main");
assert(~isempty(exe), "need to 'buildtool compile'")

%% assemble stdin
% notice that the last character is a newline.
in_stream = sprintf('%f %f\n', a, b);

%% run via Python
ret = py.subprocess.check_output(exe, pyargs(input=in_stream, text=true, timeout=5));
% this raises Matlab error if executable fails
%% parse output
ab_sum = cell2mat(textscan(char(ret), '%f', CollectOutput=true));
end
