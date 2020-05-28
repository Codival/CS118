#include <iostream>
#include <iomanip>

extern "C" void _asmMain();

extern "C" void _printString(char * s){
    std::cout << s;
}

extern "C" void _printString2(char *s, char* t){
    std::cout << s << t << std::endl;
}

extern "C" int _getInt(){
    int i;
    std::cin >> i;
    return i;
}

int main(){
    _asmMain();
    return 0;
}

























































// SWAG BITCHES IN THIS BITCH YUOU KN OW THAT 
