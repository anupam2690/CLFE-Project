#ifndef LINE2_H
#define LINE2_H
#include <Element.h>

class Line2 : public Element
{
    public:
        Line2(int no, Node* pN1, Node* pN2, double t);
        virtual ~Line2();

        double  t;          // element thickness
        double  dL;         // element length

        void    setData();  // calculate element results
        void    listData(); // list special Line2 data
    protected:

    private:
};

#endif // LINE2_H
