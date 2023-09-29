function plan = buildfile
plan = buildplan(localfunctions);
plan.DefaultTasks = "test";
plan("test").Dependencies = ["check", "compile"];
end

function checkTask(~)
% Identify code issues (recursively all Matlab .m files)
issues = codeIssues;
assert(isempty(issues.Issues), formattedDisplayText(issues.Issues))
end

function compileTask(context)
rootFolder = context.Plan.RootFolder;
bindir = fullfile(rootFolder, "build");

cmake(rootFolder, bindir)

end

function testTask(context)

r = runtests(fullfile(context.Plan.RootFolder, "test"), UseParallel=true);

assert(~isempty(r), 'No tests were run.')

assertSuccess(r)
end
