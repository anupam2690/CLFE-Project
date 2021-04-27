#ifndef BASE_H
#define BASE_H

class Base
{
    public:
        Base();
        virtual ~Base();

        static int counter;        // instance counter
        // log file name
        static char logFile[256];

        // message buffer
        static char msg[256];

        // write into the log
        static void appendLog(const char* str); // constant string
        static void appendLog(char* str);       // variable string

    protected:

    private:
};

#endif // BASE_H
