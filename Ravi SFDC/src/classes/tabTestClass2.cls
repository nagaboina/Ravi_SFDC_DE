public with sharing class tabTestClass2
{
   
    string res='false';
    public String getTabTwo() 
    {
        
        return res;
    }
    public void tabTwoAcn() 
    {
        system.debug('**************'+res);
        res='true';   
    }
    

}