function tests = testUnit
tests = functiontests(localfunctions);
end

function test_java(tc)
tc.assumeNotEmpty(find_exe("main"), "could not find main exe")
a = 3.5;
b = 7.75;
tc.verifyEqual(main_java(a,b), a+b)
end

function test_python(tc)
tc.assumeTrue(check_python_arch(), "Python arch ~= Matlab arch")
tc.assumeNotEmpty(find_exe("main"), "could not find main exe")
a = 3.5;
b = 7.75;
tc.verifyEqual(main_python(a,b), a+b)
end
