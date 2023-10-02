classdef TestSubprocessPython < matlab.unittest.TestCase

properties
sum_exe = fullfile(fileparts(mfilename("fullpath")), "../build/stdin_sum_print");
env_exe = fullfile(fileparts(mfilename("fullpath")), "../build/env_print");
a = 3;
b = 3;
end

methods (TestClassSetup)
function path_get(tc)
if ispc
  tc.sum_exe = tc.sum_exe + ".exe";
  tc.env_exe = tc.env_exe + ".exe";
end
mustBeFile(tc.sum_exe)
mustBeFile(tc.env_exe)
end
end

methods (Test)

function TestPythonSum(tc)
in_stream = sprintf('%f %f\n', tc.a, tc.b);

try
[status, msg] = subprocess_run_python(tc.sum_exe, stdin=in_stream);
catch excp
  if excp.identifier == "MATLAB:Python:PythonUnavailable" || contains(excp.message, "Unable to resolve the name py.subprocess.run")
    tc.assumeTrue(false, "Python not available")
  end
  rethrow(excp)
end
tc.assertEqual(status, 0, "subprocess_run_python failed: " + msg)

%% parse output
ab_sum = cell2mat(textscan(msg, '%f', CollectOutput=true));

tc.verifyEqual(ab_sum, tc.a + tc.b)
end

function TestPythonEnv(tc)
%% test setting an env var and printing its value
env = struct(TESTMATVAL123="hi_there");

try
[status, msg] = subprocess_run_python([tc.env_exe, "TESTMATVAL123"], env=env);
catch excp
  if excp.identifier == "MATLAB:Python:PythonUnavailable" || contains(excp.message, "Unable to resolve the name py.subprocess.run")
    tc.assumeTrue(false, "Python not available")
  end
  rethrow(excp)
end
tc.assertEqual(status, 0, "subprocess_run_python failed: " + msg)

%% parse output
tc.verifyEqual(msg, env.TESTMATVAL123)
end

end

end
