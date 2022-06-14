function plan = buildfile
plan = buildplan(localfunctions);
end

function compileTask(context)
cwd = context.Plan.RootFolder;
% cmake(cwd, fullfile(cwd, "build"))
exe = compile(fullfile(cwd, "main.cpp"));

assert(isfile(exe), "failed to build/find main")
end

function testTask(~)

assertSuccess(runtests)

end
