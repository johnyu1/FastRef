Feature: Upload document
	
	Scenario: User uploads file
		Given User not logged in
		When User accesses file
		Then Not Found

	Scenario: User access file while logged in
		Given User logged in
		When User accesses file
		Then Not Found