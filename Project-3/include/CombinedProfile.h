#ifndef COMBINEDPROFILE_H
#define COMBINEDPROFILE_H
#include "Profile.h"

class CombinedProfile : public Profile
{
    public:
        CombinedProfile(const char* pName,double k, double bb, double z, double d,double Tt,int nodes);
        virtual ~CombinedProfile();

        char      pName[256];     // profile name
        double    k;              // Length of long plate of L-Profile
        double    bb;             // Length of short plate of L-Profile
        double    z;              // thickness of L-Profile
        double    d;              // Outer diameter of O-Profile
        double    Tt;             // Thickness of O-Profile
        int       nodes;          // Total nodes on O-Profile

        void check();             // checks the profile's parameter
        void create();            // creates nodes, elements
        void listData();          // print profile's data

    protected:
    private:
};

#endif // COMBINEDPROFILE_H
