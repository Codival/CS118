#include <iostream>
#include <iomanip>


extern "C" void _asmMain();

extern "C" void _printString(char* s) {
    std::cout << s;
}

extern "C" double _getDouble(){
    double d;
    std::cin >> d;
    return d;
}

extern "C" void _printFloat(float d){
    std::cout << d << std::endl;
}

int main(){
    _asmMain();
    return 0;
}
