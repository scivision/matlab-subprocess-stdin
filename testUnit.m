function tests = testUnit
tests = functiontests(localfunctions);
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
