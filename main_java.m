function ab_sum = main_java(a, b, exe)
%% demo adding two number via Fortran executable called by Java
arguments
  a (1,1) {mustBeReal}
  b (1,1) {mustBeReal}
  exe (1,1) string {mustBeNonzeroLengthText}
end

assert(isfile(exe), "please build project with CMake or 'buildtool compile'")

%% assemble stdin
% notice that the last character is a newline.
in_stream = sprintf('%f %f\n', a, b);

%% run via Java
proc = java.lang.ProcessBuilder(exe);
h = proc.start();

stdin = h.getOutputStream();
stdout = h.getInputStream();

writer = java.io.BufferedWriter(java.io.OutputStreamWriter(stdin));
reader = java.io.BufferedReader(java.io.InputStreamReader(stdout));

writer.write(in_stream);
writer.flush()
writer.close()

line = reader.readLine();
i = 1;
msg = "";
while ~isempty(line)
  msg = append(msg, newline, string(line));
  line = reader.readLine();
  i = i + 1;
end
reader.close()
h.destroy()
assert(h.exitValue() == 0, 'problem running %s', exe)
%% parse output
ab_sum = cell2mat(textscan(msg, '%f', CollectOutput=true));
end
