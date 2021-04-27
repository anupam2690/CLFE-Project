/*
Testing environment for the Thin Walled Approximation Library
*/
#include <stdio.h>
#define CHECK_COMBINEDPROFILE
#include "Base.h"
#include "Node.h"
#include "Element.h"
#include "Profile.h"
#include "CombinedProfile.h"
#include <math.h>

int main()
{
#ifdef CHECK_COMBINEDPROFILE
    try
    {
        // Insert the value from 1 to 3 for selecting the particular Combined Profile                                                             // h    w   c    t   s   ct  total num. of nodes on both Circles
        int a = 1;

        if (a ==1)
        {                                                            // |k  |bb |z  |d    |Tt  |nodes
            CombinedProfile* p = new CombinedProfile("CombinedProfile1",100, 50, 6, 60.3, 2.3, 20);
            p->setData();
            p->listData();
        }

        else if (a==2)
        {                                                            // |k   |bb |z  |d   |Tt  |nodes
            CombinedProfile* p = new CombinedProfile("CombinedProfile2",100, 75, 10, 60.3, 2.3, 20);
            p->setData();
            p->listData();
        }

        else
        {                                                            // |k   |bb |z |d    |Tt  |nodes
            CombinedProfile* p = new CombinedProfile("CombinedProfile3",120, 80, 8, 60.3, 2.3, 20);
            p->setData();
            p->listData();
        }

    }
        catch (const char* e)
        {
            Base::appendLog(e);
        }

        catch (char* e)
        {
            Base::appendLog(e);
        }

#endif // CHECK_COMBINEDPROFILE

    return 0;
}





