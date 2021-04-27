#include <string.h>     //strcpy
#include <stdio.h>
#include "Profile.h"
#include "Node.h"
#include "Element.h"
#include <math.h>

//  constructor                     |call Base class
Profile::Profile(const char *pName) : Base()
{
    //     |destination
    //                 source   : this->pName = pName
    strcpy(this->pName,pName);
    // initialize containers
    pEC = NULL;     // no memory available!!!
    nEC = 0;
    pNC = NULL;     // no memory available!!!
    nNC = 0;
}
//destructor
Profile::~Profile()
{
    init();
}
// delete nodes and elements
void Profile::init()
{
    // delete elements
    for (int i=0;i<nEC;i++)
    {
        if (pEC[i]) delete pEC[i];
    }
    // delete nodes
    for (int i=0;i<nNC;i++)
    {
        if (pNC[i]) delete pNC[i];
    }
    // delete the containers
    if (pEC) delete [] pEC;
    if (pNC) delete [] pNC;
    // initialize
    pEC = NULL; nEC = 0;
    pNC = NULL; nNC = 0;
}
// add the containers
void Profile::addContainers(int nElements, int nNodes)
{
    // first initialize containers
    init();
    // allocate container arrays
    // - Element container
    pEC = new Element*[nElements];
    if (!pEC)   throw("*** error: creating element container!");
    nEC = nElements;
    //      |starting address
    //                | byte for initalization
    //                  |number of bytes of an Element address
    memset((void*)pEC,0,sizeof(Element*)*nEC);
    sprintf(msg,"> container for %d elements created!",nEC);
    appendLog(msg);
    // - Node container
    pNC = new Node*[nNodes];
    if (!pNC)   throw("*** error: creating node container!");
    nNC = nNodes;
    //      |starting address
    //                | byte for initailization
    //                  |number of bytes of an Element address
    memset((void*)pNC,0,sizeof(Node*)*nNC);
    sprintf(msg,"> container for %d node created!",nNC);
    appendLog(msg);
}
// add an element
void Profile::addElement(Element* pE)
{
    if (!pE)  throw("*** error: element address invalid!");
    if (!pEC) throw("*** error: no element container found!");
    // check element number
    int nEInd = pE->no -1;
    if (nEInd < 0)   throw("*** error: invalid element number!");
    if (nEInd >= nEC)throw("*** error: element container overflow!");
    //  it's used  and not the same
    if (pEC[nEInd] && pEC[nEInd] != pE)
    {
        sprintf(msg,"*** error: element %d already set!",pE->no);
        throw(msg);
    }
    // store it!
    pEC[nEInd] = pE;
    // add the nodes
    //             |number element nodes
    for (int i=0;i<pE->nN;i++)
    {
        // get node address
        Node* pN = pE->pN[i];
        // add node to the profile
        addNode(pN);
    }
}
// check and add a Node object
void Profile::addNode(Node* pN)
{
    if (!pN)  throw("*** error: node address unvalid!");
    if (!pNC) throw("*** error: no node container found!");
    // check node number
    int nNInd = pN->no -1;
    if (nNInd < 0)   throw("*** error: unvalid node number!");
    if (nNInd >= nNC)throw("*** error: node number out of range!");
    //  it's used  and not the same
    if (pNC[nNInd] && pNC[nNInd] != pN)
    {
        sprintf(msg,"*** error: node %d already set!",pN->no);
        throw(msg);
    }
    // store it!
    pNC[nNInd] = pN;
}
// calculate section values of the profile
void Profile::setData()
{
    dA = 0.;
    memset((void*)dS,0,sizeof(double)*2);
    memset((void*)dIu,0,sizeof(double)*3);
    // over all elements
    for (int i=0;i<nEC;i++)
    {
        Element* pE = pEC[i];
        if (!pE) continue;      // if (pE == NULL) ...
        pE->setData();          // call specific element method
        dA += pE->dA;
        for(int i=0;i<2;i++)  dS[i]  += pE->dS[i];
        for(int i=0;i<3;i++)  dIu[i] += pE->dI[i];
    }
    // center of mass coordinates
    for (int i=0;i<2;i++) de[i] = dS[(i+1)%2]/dA;
    // moment of inertia  in center of mass coordinates
    dIc[0] = dIu[0] - de[1]*de[1]*dA;
    dIc[1] = dIu[1] - de[0]*de[0]*dA;
    dIc[2] = dIu[2] - de[0]*de[1]*dA;
    // main axis transformation
    double dISum = dIc[0] + dIc[1];
    double dIDif = dIc[0] - dIc[1];
    double dISqr = sqrt(pow(dIDif,2) + 4.*pow(dIc[2],2));
    dIp[0] = (dISum + dISqr)/2.;
    dIp[1] = (dISum - dISqr)/2.;
    dAngle = 0.5*atan2(2.*dIc[2],dIDif);
}
// print profile data
void Profile::listData()
{
    sprintf(msg,"> Profile.................: '%s'",pName);
    appendLog(msg);
    appendLog("> List of profile's section values:");
    sprintf(msg,"  Area......................: %10.2f cm^2",dA/1.e+2);
    appendLog(msg);
    sprintf(msg,"  Sy,Sz.in user coord....: %10.2f %10.2f cm^3",
            dS[0]/1.e+3,dS[1]/1.e+3);
    appendLog(msg);
    sprintf(msg,"  Iyy,Izz,Iyz.in user coord: %10.2f %10.2f %10.2f cm^4",
            dIu[0]/1.e+4,dIu[1]/1.e+4,dIu[2]/1.e+4);
    appendLog(msg);
    sprintf(msg,"  yc,zc.(center of mass).: %10.2f %10.2f cm",
            de[0]/1.e+1,de[1]/1.e+1);
    appendLog(msg);
    sprintf(msg,"  Iyy,Izz,Iyz.in com. coord: %10.2f %10.2f %10.2f cm^4",
            dIc[0]/1.e+4,dIc[1]/1.e+4,dIc[2]/1.e+4);
    appendLog(msg);
    sprintf(msg,"  Ieta,Izeta in pri. coord : %10.2f %10.2f cm^4",
            dIp[0]/1.e+4,dIp[1]/1.e+4);
    appendLog(msg);

    double dAngleDeg = dAngle*45./atan(1.);
    if (fabs(dAngleDeg -90.) < 1.e-10)
    {
        sprintf(msg,"  Angle                  : %10.2f �",dAngleDeg);
        appendLog(msg);
    }
    else
    {
        sprintf(msg,"  Angle, tan(Angle)      : %10.2f � (tan(%.2f) = %.2f)",
                dAngleDeg,dAngleDeg,tan(dAngle));
        appendLog(msg);
    }
}
