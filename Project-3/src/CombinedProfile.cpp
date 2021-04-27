#include "CombinedProfile.h"
#include "Element.h"
#include <stdio.h>
#include <math.h>
#include "Line2.h"
// constructor
CombinedProfile::CombinedProfile(const char* pName,double k, double bb, double z, double d,double Tt,int nodes) :
    Profile(pName)       // Never forget to call the base class constructor
{
    this->k     = k;     // Length of long plate of L-Profile
    this->bb    = bb;    // Length of short plate of L-Profile
    this->z     = z;     // Thickness of L-Profile
    this->d     = d;     // Outer diameter of O-Profile
    this->Tt    = Tt;    // Thickness of O-Profile
    this->nodes = nodes; // Total nodes on both Circles

    check();
    create();
}
// destructor
CombinedProfile::~CombinedProfile()
{
    //destructor
}
// checking profile parameters
void CombinedProfile::check()
{
    double dEps = 0.5;
    if (k<dEps)     throw "Error: Invalid k!";
    if (bb<dEps)    throw "Error: Invalid bb!";
    if (z<dEps)     throw "Error: Invalid z!";
    if (d<dEps)     throw "Error: Invalid d!";
    if (Tt<dEps)    throw "Error: Invalid Tt!";
    if (nodes<20)   throw "*** Increase the number of nodes ***";
}
// create profile geometry
void CombinedProfile::create()
{
    double radius = d/2;
    double pi     = atan(1)*4;

    int x = (nodes+4);
    int y = (nodes+6);
    // add container
    //            |elements
    //              |nodes
    addContainers(x,y);

    Node*   pN[y];
    Line2*  pL[x];

    // Create geometry of O-Profile
    float a[nodes];
    float b[nodes];
    for (int i = 0; i < nodes; i+=1 )
    {
        float theta= (2*pi/nodes)*i;
        a[i] = ( radius*cos(theta) );
        b[i] = ( bb + radius*sin(theta) );
    }

    // Create nodes of O-Profile
    for (int i = 0; i <nodes; i+=1 )
    {
        if(i==(nodes-1))
        {
            pN[nodes-1]  = new Node(nodes, a[nodes-1], b[nodes-1]);
        }
        else
        {
            pN[i]  = new Node(i+1, a[i], b[i]);
        }
    }

    // Create elements of O-Profile
    for (int i = 0; i <nodes; i+=1 )
    {
        if (i == (nodes-1))
        {
            pL[nodes-1] = new Line2(nodes,pN[0],pN[nodes-1],Tt);
        }

        else
        {
            pL[i] = new Line2(i+1,pN[i],pN[i+1],Tt);
        }
    }
    // create geometry of L-Profile
    // create nodes of L-Profile
    pN[nodes]    = new Node(nodes+1, -radius - k,  z/2);
    pN[nodes+1]  = new Node(nodes+2, -radius,  z/2);
    pN[nodes+2]  = new Node(nodes+3, -radius,  bb);
    pN[nodes+3]  = new Node(nodes+4,  radius,  bb);
    pN[nodes+4]  = new Node(nodes+5,  radius,  z/2);
    pN[nodes+5]  = new Node(nodes+6,  radius + k,  z/2);

    // create elements of L-profile
    pL[nodes]    = new Line2(nodes+1  ,pN[nodes  ]   ,pN[nodes+1],z);
    pL[nodes+1]  = new Line2(nodes+2  ,pN[nodes+1]   ,pN[nodes+2],z);
    pL[nodes+2]  = new Line2(nodes+3  ,pN[nodes+3]   ,pN[nodes+4],z);
    pL[nodes+3]  = new Line2(nodes+4  ,pN[nodes+4]   ,pN[nodes+5],z);

    // add elements
    for (int i=0;i<x;i++) addElement(pL[i]);

}

// print profile data
void CombinedProfile::listData()
{
    sprintf(msg,">   Combined Profile......................: '%s'",pName);
    appendLog(msg);
    sprintf(msg,">   L - Long plate........................: %12.1f mm" ,bb);
    appendLog(msg);
    sprintf(msg,">   L - Short plate.......................: %12.1f mm" ,k);
    appendLog(msg);
    sprintf(msg,">   L - profile thickness.................: %12.1f mm" ,z);
    appendLog(msg);
    sprintf(msg,">   O - outer diameter....................: %12.1f mm" ,d);
    appendLog(msg);
    sprintf(msg,">   O - profile thickness.................: %12.1f mm" ,Tt);
    appendLog(msg);
    sprintf(msg,">   Nodes on O - profile .................: %d" ,nodes);
    appendLog(msg);

    Profile::listData();
}


