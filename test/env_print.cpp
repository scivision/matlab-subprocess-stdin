#include <iostream>
#include <cstdlib>

int main(int argc, char** argv) {

if(argc != 2 ){
    std::cerr << "Usage: " << argv[0] << " <env var name to print>" << std::endl;
    return EXIT_FAILURE;
}

char* a = std::getenv(argv[1]);
if(!a){
    std::cerr << "Environment variable " << argv[1] << " not found" << std::endl;
    return EXIT_FAILURE;
}

std::cout << a << std::endl;

return EXIT_SUCCESS;

}
