function [status, msg] = subprocess_run(cmd_array, opt)

arguments
  cmd_array (1,:) string
  opt.env struct {mustBeScalarOrEmpty} = struct.empty
  opt.cwd string {mustBeScalarOrEmpty} = string.empty
  opt.stdin string {mustBeScalarOrEmpty} = string.empty
end

exe = space_quote(cmd_array(1));

if length(cmd_array) > 1
  cmd = append(exe, " ", join(cmd_array(2:end), " "));
else
  cmd = exe;
end


%% process instantiation
proc = java.lang.ProcessBuilder(cmd);

if ~isempty(opt.env)
  env = proc.environment();
  env.putAll(opt.env);
end

if ~isempty(opt.cwd)
  assert(isfolder(opt.cwd), "subprocess_run: %s is not a folder", opt.cwd)
  proc.directory(java.io.File(opt.cwd));
end

%% start process
h = proc.start();

%% stdin pipe
if ~isempty(opt.stdin)
  writer = java.io.BufferedWriter(java.io.OutputStreamWriter(h.getOutputStream()));
  writer.write(opt.stdin);
  writer.flush()
  writer.close()
end

%% stdout pipe
reader = java.io.BufferedReader(java.io.InputStreamReader(h.getInputStream()));
line = reader.readLine();
msg = "";
while ~isempty(line)
  msg = append(msg, newline, string(line));
  line = reader.readLine();
end
reader.close()

%% close process handle
h.destroy()

status = h.exitValue();

end % function subprocess_run


function q = space_quote(p)
%% handle command line arguments that have spaces by quoting
arguments
  p (1,1) string
end

if ~contains(p, " ")
  q = p;
  return
end

q = append('"', p, '"');

end
