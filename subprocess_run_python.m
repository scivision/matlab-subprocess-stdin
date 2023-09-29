function [status, stdout, stderr] = subprocess_run_python(cmd_array, opt)

arguments
  cmd_array (1,:) string
  opt.env struct {mustBeScalarOrEmpty} = struct.empty
  opt.cwd string {mustBeScalarOrEmpty} = string.empty
  opt.stdin string {mustBeScalarOrEmpty} = string.empty
end

cmd_array(1) = space_quote(cmd_array(1));

if ~isempty(opt.env)
  % TODO: to make this not set in Matlab global scope, we need to getenv()
  % and then append desired env var to that struct.
  % otherwise, subprocess.run is missing needed system environment
  % variables and any run fails
  fields = fieldnames(opt.env);
  for i = 1:length(fields)
    setenv(fields{i}, opt.env.(fields{i}));
  end
end

if isempty(opt.stdin)
  stdin = py.None;
else
  stdin = opt.stdin;
end

if isempty(opt.cwd)
  cwd = py.None;
else
  cwd = opt.cwd;
  assert(isfolder(opt.cwd), "subprocess_run: %s is not a folder", opt.cwd)
end

args = pyargs(input=stdin, text=true, timeout=5, stdout=py.subprocess.PIPE, stderr=py.subprocess.PIPE, cwd=cwd);
% disp("Using Python: " + pyenv().Executable)

ret = py.subprocess.run(cellstr(cmd_array), args);
%% get outputs
status = double(ret.returncode);
stdout = string(ret.stdout.strip());
stderr = string(ret.stderr.strip());

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
