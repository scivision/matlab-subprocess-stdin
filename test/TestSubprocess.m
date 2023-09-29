classdef TestSubprocess < matlab.unittest.TestCase

properties
sum_exe
env_exe
a = 3;
b = 3;
end

methods (TestClassSetup)
function path_get(tc)
import matlab.unittest.fixtures.PathFixture

cwd = fileparts(mfilename("fullpath"));

tc.applyFixture(PathFixture(fullfile(cwd, "..")));

tc.sum_exe = fullfile(cwd, "../build/stdin_sum_print");
tc.env_exe = fullfile(cwd, "../build/env_print");

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

end

end