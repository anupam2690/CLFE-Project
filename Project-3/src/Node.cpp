#include "Node.h"
#include <stdio.h>  // sprintf
//constructor
//         parameters                   call base class
Node::Node(int no, double x, double y): Base()
{
    // assign the coordinate
    this->no   = no;
    this->x[0] = x;
    this->x[1] = y;
}
//destructor
Node::~Node()
{
    //destructor
}
// print node data
void Node::listData()
{
    sprintf(msg,"> node %2d: x = %12.4lf, y = %12.4lf",no,x[0],x[1]);
    appendLog(msg);     //method of base
}
