Feature:
	As an API consumer I should be able to call an available resource.
    
    
    
    
    
    Scenario: Should get a successful response from a get transaction on /hello
        Given I set User-Agent header to apickli
        
            When I GET /hello
            
            
            Then response code should be 200
            
            
    
    
    
