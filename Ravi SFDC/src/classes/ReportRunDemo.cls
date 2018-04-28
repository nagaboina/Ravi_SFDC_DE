public without sharing class ReportRunDemo {
    public void runReport(){
        Reports.ReportResults results = Reports.ReportManager.runReport('00O90000009OpeQEAS', true);
        system.debug('results ### '+results);
//        for(Reports.ReportResult obj : results){
            
  //      }
    }
}