trigger GMR_UpdateMembershipExpirationDate on Gift_GiftMembershipRelationship__c (after insert, after update) {
    
    for (Gift_GiftMembershipRelationship__c link : Trigger.New) {
        
        Membership__c membership = new Membership__c(id=link.Membership__c);
        
        System.debug( 'Gift date prefetch' );
        
        Date giftDate = Date.valueOf([select Gift_Date__c from Gift__c where ID = :link.Gift__c LIMIT 1].Gift_Date__c); 
        
        System.debug( 'Gift date is :' + giftDate );
        
        membership.Expiration_Date__c = giftDate.addYears( 1 );
        
        update membership;
    }
    
}