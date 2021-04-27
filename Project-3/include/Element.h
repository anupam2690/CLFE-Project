#ifndef ELEMENT_H
#define ELEMENT_H
#include "Base.h"
#include "Node.h"
//                           --> helpers to do the Gauss quadrature
class Element : public Base
{
    public:
        Element();
        virtual ~Element();

        int     no;                // element number
        // double  t;              // element thickness -> Line2, Arc
        //  |Node address
        //   |array of Node addresses
        Node**  pN;
        int     nN;             // number of nodes

        static double  dAmin;   // minimal area

        // element results (section values)
        double  dA;             // area
        double  dS[2];          // 1st moment (static moment)
        double  dI[3];          // 2nd moment (moment of inertia)

        void checkNodes();      // check node addresses

        // polymorphism
        virtual void setData(); // should be implemented in the child classes
        // virtual void listData();// should be implemented in the child classes
        void listResults();

    protected:

    private:
};

#endif // ELEMENT_H
