function plan = buildfile
plan = buildplan(localfunctions);
plan.DefaultTasks = "test";
plan("test").Dependencies = "check";
end

function checkTask(~)
% Identify code issues (recursively all Matlab .m files)
issues = codeIssues;
assert(isempty(issues.Issues),formattedDisplayText(issues.Issues))
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
