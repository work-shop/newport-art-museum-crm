trigger GMR_UpdateMembershipExpirationDate on Gift_GiftMembershipRelationship__c (after insert, after update) {
        
   UpdateMembershipDates.updateMembershipExpirationDate( Trigger.New );
    
}