classdef TestSubprocess < matlab.unittest.TestCase

properties 
sum_exe = fullfile(fileparts(mfilename("fullpath")), "build/stdin_sum_print");
env_exe = fullfile(fileparts(mfilename("fullpath")), "build/env_print");
a = 3;
b = 3;
end

methods (TestClassSetup)
function path_get(tc)
if ispc
  tc.sum_exe = tc.sum_exe + ".exe";
  tc.env_exe = tc.env_exe + ".exe";
end
end
end

methods (Test)

function TestJavaSum(tc)
%% assemble stdin
% notice that the last character is a newline.
tc.assumeTrue(isfile(tc.sum_exe), tc.sum_exe + " is not a file")

in_stream = sprintf('%f %f\n', tc.a, tc.b);

[status, msg] = subprocess_run(tc.sum_exe, stdin=in_stream);
tc.assertEqual(status, 0, "subprocess_run failed: " + msg)

%% parse output
ab_sum = cell2mat(textscan(msg, '%f', CollectOutput=true));

tc.verifyEqual(ab_sum, tc.a + tc.b)
end

function TestJavaEnv(tc)
%% test setting an env var and printing its value
tc.assumeTrue(isfile(tc.sum_exe), tc.sum_exe + " is not a file")

env = struct(TESTMATVAL123="hi_there");

[status, msg] = subprocess_run([tc.env_exe, "TESTMATVAL123"], env=env);
tc.assertEqual(status, 0, "subprocess_run failed: " + msg)

%% parse output
tc.verifyEqual(msg, env.TESTMATVAL123)
end

function TestPythonSum(tc)
tc.assumeTrue(isfile(tc.sum_exe), tc.sum_exe + " is not a file")

in_stream = sprintf('%f %f\n', tc.a, tc.b);

[status, msg] = subprocess_run_python(tc.sum_exe, stdin=in_stream);
tc.assertEqual(status, 0, "subprocess_run_python failed: " + msg)

%% parse output
ab_sum = cell2mat(textscan(msg, '%f', CollectOutput=true));

tc.verifyEqual(ab_sum, tc.a + tc.b)
end

function TestPythonEnv(tc)
%% test setting an env var and printing its value
tc.assumeTrue(isfile(tc.sum_exe), tc.sum_exe + " is not a file")

env = struct(TESTMATVAL123="hi_there");

[status, msg] = subprocess_run_python([tc.env_exe, "TESTMATVAL123"], env=env);
tc.assertEqual(status, 0, "subprocess_run_python failed: " + msg)

%% parse output
tc.verifyEqual(msg, env.TESTMATVAL123)
end

end

end