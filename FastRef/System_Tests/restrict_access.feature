Feature: Check restricted access to files
	
	Scenario: User access public file while not logged in
		Given User not logged in
		Given File is public
		When User accesses file
		Then OK

	Scenario: User access public file while logged in
		Given User logged in
		Given File is public
		When User accesses file
		Then OK
	
	Scenario: User access private file while not logged in
		Given User not logged in
		Given File is private
		When User accesses file
		Then Not Found

	Scenario: User access private file while logged in
		Given User logged in
		Given File is private
		When User accesses file
		Then OK

	Scenario: User uploads a public file
		Given User logged in
		When User uploads public file
		Then OK

	Scenario: User uploads a private file
		Given User logged in
		When User uploads private file
		Then OK

	Scenario: User deletes a public file
		Given User logged in
		When User deletes public file
		Then OK

	Scenario: User deletes a private file
		Given User logged in
		When User deletes private file
		Then OK

	Scenario: User adds tags to public file while not logged in
		Given User not logged in
		Given File is public
		When User adds tag
		Then OK

	Scenario: User adds tags to public file while logged in
		Given User logged in
		Given File is public
		When User adds tag
		Then OK

	Scenario: User adds tags to private file while logged in
		Given User logged in
		Given File is private
		When User adds tag
		Then OK

	
