function ab_sum = main_java(a, b, exe)
%% demo adding two number via Fortran executable called by Java
arguments
  a (1,1) {mustBeReal}
  b (1,1) {mustBeReal}
  exe (1,1) string {mustBeFile}
end

%% assemble stdin
% notice that the last character is a newline.
in_stream = sprintf('%f %f\n', a, b);

[status, msg] = subprocess_run(exe, stdin=in_stream);
assert(status == 0, 'subprocess_run failed: %s', msg);

%% parse output
ab_sum = cell2mat(textscan(msg, '%f', CollectOutput=true));

end
