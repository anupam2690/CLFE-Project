#include <stdio.h>      // for printing
#include "Element.h"    // declare the element class

double Element::dAmin = 1.; // 1 mm^2   // minimal element area
Element::Element() : Base()
{

}
// destructor: note : the Node instances have to be freed outside
Element::~Element()
{
    // delete node container
    //      | needed for arrays
    delete [] pN;
}

// check the node addresses
void Element::checkNodes()
{
    for (int i=0;i<nN;i++)
    {
        if (!pN[i])
        {
            sprintf(msg,"*** error: element %d, invalid node address %d!",this->no,i+1);
            throw(msg);
        }
    }
}
// only used for polymorphism
void Element::setData()
{
    sprintf(msg,"*** error: setData must be overwritten!");
    throw(msg);
}

// list general section values
void Element::listResults()
{
    // print node data
    for (int i=0;i<nN;i++)  pN[i]->listData();
    // section values
    sprintf(msg,"    A....................: %12.2f mm^2",dA);
    appendLog(msg);
    sprintf(msg,"    Sx/Sy................: %12.2f %12.2f mm^3",
            dS[0],dS[1]);
    appendLog(msg);
    sprintf(msg,"    Ixx,Iyy,Ixy..........: %12.2f %12.2f %12.2f mm^4",
            dI[0],dI[1],dI[2]);
    appendLog(msg);
}
