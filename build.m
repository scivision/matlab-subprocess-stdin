function build(src, exe)
arguments
  src (1,1) string
  exe (1,1) string
end

if ~isfile(exe)
  ret = system("gfortran " + src + " -o " + exe);
  assert(ret == 0)
end

end
