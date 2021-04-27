#include "Base.h"   // project include
#include <stdio.h>  // file printing
// implimentation of a static attribute
int  Base::counter      = 0;
char Base::logFile[256] = "twa.log";
char Base::msg[256]     = {0};

// constructor
// |class name
//    |function name
Base::Base()
{
    // count instances
    counter++;
    //ctor
}

//destructor should be implemented because it's virtual
Base::~Base()
{
    counter--;
}

// print into the log
void Base::appendLog(char* str)
{
    appendLog((const char*)str);
}

// print into the log
void Base::appendLog(const char* str)
{
    printf("%s\n",str);
    // mode: "r": read, "w": write, "rw": read and write "a"
    //                |filename
    //                        |mode
    //    |file handle -> pointer to a datastructure
    FILE* pHnd =fopen(logFile,"a");
    // if (pHnd == NULL) ...
    // if (pHnd == 0) ...
    if (!pHnd) return;

    fprintf(pHnd,"%s\n",str);
    fclose(pHnd);
}
