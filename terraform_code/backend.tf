terraform {

    backend "s3"{

        bucket = "s3-statefile-test-terraform"
        region="us-east-1"
        #versioning=true    it is not allowed here we must enable in console
        key="statefile/terraform.tfstate"
        use_lockfile = true
        encrypt = true
        #dynamodb_table = "provide dynamodb table"  #partion key must be LockId


        
        #we can also use dynamobd for locking mechansim 
        #where we store the lock inside the primary key(partion key --> LockId) of dynmaodb table
        #when ever user trying to to apply  then the terraform of that user side tries to take that lock 
        #inside that partion key if it is not already taken it allows to take that lock else w ehave to wait
        #if weget lock we able to access teh s3 bucket to do changes in the statefile
    }
  
}