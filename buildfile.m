function plan = buildfile
plan = buildplan(localfunctions);
plan.DefaultTasks = "test";
plan("test").Dependencies = ["check", "compile"];
end

function checkTask(~)
% Identify code issues (recursively all Matlab .m files)
issues = codeIssues;
assert(isempty(issues.Issues),formattedDisplayText(issues.Issues))
end

function compileTask(context)
rootFolder = context.Plan.RootFolder;
bindir = fullfile(rootFolder, "build");

cmake(rootFolder, bindir)

end

function testTask(~)

r = runtests(UseParallel=true);

assert(~isempty(r), 'No tests were run.')

if sum([r.Incomplete]) ~= 0
  warning("Some tests were skipped.")
  exit(77)
end

assertSuccess(r)
end
