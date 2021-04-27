#ifndef NODE_H
#define NODE_H
#include "Base.h"

class Node : public Base
{
    public:
        Node(int no, double x, double y);
        virtual ~Node();

        int     no;         // node number
        double  x[2];       // coordinates

        void    listData(); // write data into log

    protected:

    private:
};

#endif // NODE_H
