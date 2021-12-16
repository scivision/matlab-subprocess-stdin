function build(src, exe)
%% builds a C file, assuming that "cc" is the C compiler
arguments
  src (1,1) string
  exe (1,1) string
end

if ~isfile(exe)
  ret = system("c++ " + src + " -o " + exe);
  assert(ret == 0)
end

end
