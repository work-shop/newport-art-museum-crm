public class UpdateMembershipDates {

    
    /**
     * This routine gets the extended set of gifts related to a given membership_id
     * 
     * @param Id membership_id the membership id to get gifts for
     * @return List<Gift__c> the set of `Gift__c`s to related to this membership through a Gift_GMR junction record.
	 */
    public static List<Gift__c> getGiftSetForMembership( Id membership_id ) {
        return [select Id, Gift_Date__c from Gift__c where Id in (select Gift__c from Gift_GiftMembershipRelationship__c where Membership__c = :membership_id )];
    }
    
    
    /**
     * This routine updates the expiration date of a given membership
     * based on the Gift Date of the latest gift associated with the
     * given membership.
     * 
     * @param List<Gift_GiftMembershipRelationship__c> links the Junction Object link between the membership and the gift
     * 
     **/
    public static void updateMembershipExpirationDate( List<Gift_GiftMembershipRelationship__c> links ) {
        
        for ( Gift_GiftMembershipRelationship__c link : links ) {
            
            Membership__c membership = new Membership__c(id=link.Membership__c);
            
            List<Gift__c> gifts = getGiftSetForMembership( membership.Id );
            
            // We know that there is at least one such, 
            // because we encountered this membership 
            // through a gift relation.
            Date endDate = Date.valueOf( ((Gift__c) gifts.remove(0)).Gift_Date__c ).addYears( 1 );
         	 
            for ( Gift__c gift : gifts ) {
                
                Date possibleEndDate = Date.valueOf( gift.Gift_Date__c ).addYears( 1 );
                
                if ( endDate < possibleEndDate ) {
                    
                    endDate = possibleEndDate;
                    
                }
                
            }
            
            membership.Expiration_Date__c = endDate;
            
            update membership;
                  
        }
        

        /**
        Membership__c membership = [select Id, Expiration_Date__c from Membership__c where Id = :link.Membership__c];
       
        Date giftDate = Date.valueOf([select Gift_Date__c from Gift__c where ID = :link.Gift__c LIMIT 1].Gift_Date__c); 
        
        Date candidateExpirationDate = giftDate.addYears( 1 );
        
        if ( Date.valueOf( membership.Expiration_Date__c ) < candidateExpirationDate ) {
            
            membership.Expiration_Date__c = candidateExpirationDate;

			update membership;  
            
        } 
		*/
        
    }

    
	/**
     * This routine updates the start date of a given membership
     * based on the Gift Date of the earliest gift associated with the
     * given membership.
     * 
     * @param List<Gift_GiftMembershipRelationship__c> links the Junction Object link between the membership and the gift
     * 
     **/    
    public static void updateMembershipStartDate( List<Gift_GiftMembershipRelationship__c> links ) {
        
        for ( Gift_GiftMembershipRelationship__c link : links ) {
            
            Membership__c membership = new Membership__c(id=link.Membership__c);
            
            List<Gift__c> gifts = getGiftSetForMembership( membership.Id );
            
            // We know that there is at least one such, 
            // because we encountered this membership 
            // through a gift relation.
            Date startDate = ((Gift__c) gifts.remove(0)).Gift_Date__c;
            
            for ( Gift__c gift : getGiftSetForMembership( membership.Id ) ) {
                
                if ( startDate > gift.Gift_Date__c ) {
                    
                    startDate = gift.Gift_Date__c;
                    
                }
                
            }
            
            membership.Start_Date__c = startDate;
            
            update membership;
            
        }
        
        /*
        Date giftDate = Date.valueOf([select Gift_Date__c from Gift__c where ID = :link.Gift__c LIMIT 1].Gift_Date__c);
        Membership__c membership = [select Id, Start_Date__c from Membership__c where Id = :link.Membership__c];
        
        System.debug( 'Gift Date: ' + giftDate );
        System.debug( 'Membership Start Date: ' + membership.Start_Date__c );
        
        if ( membership.Start_Date__c > giftDate || membership.Start_Date__c == null ) {
            
            membership.Start_Date__c = giftDate;
            
            update membership;
            
        } 
		*/
        
    }
}