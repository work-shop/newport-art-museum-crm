trigger G_UpdateMembershipExpirationDate on Gift__c (after insert, after update) {
    
    Set<Id> gift_ids = Trigger.newMap.keySet();
    List<Gift_GiftMembershipRelationship__c> links = [select Id, Membership__c, Gift__c from Gift_GiftMembershipRelationship__c where Gift__c in :gift_ids];
        
    UpdateMembershipDates.updateMembershipExpirationDate( links );
  
}