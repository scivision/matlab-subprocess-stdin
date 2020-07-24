function main_java(a, b)
%% demo adding two number via Fortran executable called by Java
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
proc = java.lang.ProcessBuilder(exe);
h = proc.start();

stdin = h.getOutputStream();
stdout =h.getInputStream();

writer = java.io.BufferedWriter(java.io.OutputStreamWriter(stdin));
reader = java.io.BufferedReader(java.io.InputStreamReader(stdout));

writer.write(in_stream);
writer.flush()
writer.close()

line = reader.readLine();
i = 1;
msg = '';
while ~isempty(line)
  msg = [msg, newline, char(line)];
  line = reader.readLine();
  i = i + 1;
end
reader.close()
h.destroy()
assert(h.exitValue()==0, 'problem running executable')
%% parse output
ab_sum = cell2mat(textscan(msg, '%f', 'CollectOutput', true));

fprintf('%f + %f = %f\n', a, b, ab_sum)
end
