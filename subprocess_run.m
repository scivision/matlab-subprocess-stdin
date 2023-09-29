function [status, msg] = subprocess_run(cmd, opt)
%% use Matlab Java ProcessBuilder interface to run subprocess and use stdin/stdout pipes
arguments
  cmd (1,:) string
  opt.env struct {mustBeScalarOrEmpty} = struct.empty
  opt.cwd string {mustBeScalarOrEmpty} = string.empty
  opt.stdin string {mustBeScalarOrEmpty} = string.empty
end

cmd(1) = space_quote(cmd(1));

%% process instantiation
proc = java.lang.ProcessBuilder(cmd);

if ~isempty(opt.env)
  % requires Parallel Computing Toolbox
  env = proc.environment();
  fields = fieldnames(opt.env);
  for i = 1:length(fields)
    env.put(fields{i}, opt.env.(fields{i}));
  end
end

if ~isempty(opt.cwd)
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
  msg = append(msg, string(line), newline);
  line = reader.readLine();
end
msg = strip(msg);
reader.close()

%% wait for process to complete
status = h.waitFor();

h.destroy()

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
