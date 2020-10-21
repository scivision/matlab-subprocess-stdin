function tests = testUnit
tests = functiontests(localfunctions);
end

function setupOnce(tc)
import matlab.unittest.constraints.IsFile
exe = "main.bin";
build("main.f90", exe)
tc.assumeThat(exe, IsFile)
end

function test_java(tc)
a = 3.5;
b = 7.75;
tc.verifyEqual(main_java(a,b), a+b)
end

function test_python(tc)
a = 3.5;
b = 7.75;
tc.verifyEqual(main_python(a,b), a+b)

end
