#include <stdio.h>
#include <math.h>
#include "Line2.h"

Line2::Line2(int no, Node* pN1, Node* pN2, double t)
{
    this->no    = no;
    this->t     = t;
    // create node container
    //       |---- data type
    //            |-- container length
    pN = new Node*[2];
    // if (!pN) throw .....
    nN = 2;            // array dimension
    // store node addresses
    pN[0] = pN1;
    pN[1] = pN2;
    // check node addresses
    checkNodes();                   // Elements checkNodes
    // check special features
    if (t < 0.1)
    {
       sprintf(msg,"*** error: element %d, invalid thickness %.2fmm!",this->no,t);
       throw(msg);
    }
}

//destructor
Line2::~Line2()
{
    //destructor
}

// calculate section values
void Line2::setData()
{
    // helpers
    double  dLp[2];     // projected length
    double  dxc[2];     // center coordinate
    // calculate the helpers
    for (int i=0;i<2;i++)
    {
        dLp[i] = pN[1]->x[i] -pN[0]->x[i];
        dxc[i] = (pN[1]->x[i] +pN[0]->x[i])/2.;
    }
    // element length
    dL = sqrt(pow(dLp[0],2) +pow(dLp[1],2));
    // calculate the area
    dA = dL*t;
    if (dA < dAmin)
    {
        sprintf(msg,"*** error: element %d invalid area: %.2f mm^2",no,dA);
        throw(msg);
    }
    // calculate the static moment
    for (int i=0;i<2;i++)
    {
        dS[i] = dxc[(i+1)%2]*dA;
    }
    // calculate the moments of inertia
    for (int i=0;i<2;i++)
    {
        int j = (i+1)%2;
        dI[i] = (pow(dLp[j],2)/12. + pow(dxc[j],2))*dA;
    }
    dI[2] = (dLp[0]*dLp[1]/12. + dxc[0]*dxc[1])*dA;
}
// print special Line2 features
void Line2::listData()
{
    sprintf(msg,"> element %d (Line2), t = %.2f mm, L = %.2f mm",no,t,dL);
    appendLog(msg);
    // print the section values
    listResults();
}

