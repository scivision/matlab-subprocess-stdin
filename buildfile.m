function plan = buildfile
plan = buildplan(localfunctions);
end

function compileTask(context)
cwd = context.Plan.RootFolder;
% cmake(cwd, fullfile(cwd, "build"))
compile(fullfile(cwd, "main.cpp"), "main")

exe = find_exe("main");
assert(~isempty(exe), "failed to build/find main_cpp")
end

function testTask(~)

assertSuccess(runtests)

end
