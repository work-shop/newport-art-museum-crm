trigger G_UpdateMembershipExpirationDate on Gift__c (after insert, after update) {
    
    Set<Id> gift_ids = Trigger.newMap.keySet();
    List<Gift_GiftMembershipRelationship__c> links = [select Id, Membership__c, Gift__c from Gift_GiftMembershipRelationship__c where Gift__c in :gift_ids];
    
    for ( Gift_GiftMembershipRelationship__c link : links ) {
        
        Membership__c membership = new Membership__c(id=link.Membership__c);
        
        Date giftDate = Date.valueOf([select Gift_Date__c from Gift__c where ID = :link.Gift__c LIMIT 1].Gift_Date__c); 
        
        membership.Expiration_Date__c = giftDate.addYears( 1 );

		update membership;        
    }
   

}