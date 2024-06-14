#include <stdio.h>

const char * get_message();

int main()
{
    get_message();

    return 0;
}

const char * get_message()
{
    char * message = "Hello world!\n";

    printf(message);

    return 0;
}