#ifndef PROFILE_H
#define PROFILE_H
#include "Base.h"

class Node;
class Element;
class Profile : public Base
{
    public:
        Profile(const char *pName);
        virtual ~Profile();

        char      pName[256];       // profile name
        double    dA;               // area
        double    dS[2];            // static moment
        double    dIu[3];           // moment of inertia in user coordinates
        double    de[2];            // center of mass coordinates
        double    dIc[3];           // moment of inertia in com coordinates
        double    dIp[2];           // moment of inertia principle values
        double    dAngle;           // rotation angle

        Element** pEC;              // element address contain
        int       nEC;              // container length

        Node**    pNC;              // node address contain
        int       nNC;              // container length
                                    // create element and node container
        void init();                // clear profile data
        void addContainers(int nElements, int nNodes);
        void addElement(Element* pE);// store Element object
        void addNode(Node* pN);     // store Node object
        void setData();             // calculate section values
        void listData();            // print result data

    protected:

    private:
};

#endif // PROFILE_H
