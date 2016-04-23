Feature: Check FastRef functionality
	@done
	Scenario: User access public file while not logged in
		Given User not logged in
		Given File is public
		When User accesses file
		Then status code is 200
	@done
	Scenario: User access public file while logged in
		Given User logged in
		Given File is public
		When User accesses file
		Then status code is 200
	@done
	Scenario: User access private file while not logged in
		Given User not logged in
		Given File is private
		When User accesses file
		Then status code is 404
	@done
	Scenario: User access private file while logged in
		Given User logged in
		Given File is private
		When User accesses file
		Then status code is 200
	@done
	Scenario: User uploads a public file
		Given User logged in
		When User uploads file
		Then status code is 200
	@done
	Scenario: User uploads a private file
		Given User logged in
		When User uploads file
		Then status code is 200

	Scenario: User deletes a public file
		Given User logged in
		When User deletes file
		Then status code is 200

	Scenario: User deletes a private file
		Given User logged in
		When User deletes file
		Then status code is 200

	Scenario: User adds tags to public file while not logged in
		Given User not logged in
		Given File is public
		When User adds tag
		Then status code is 200

	Scenario: User adds tags to public file while logged in
		Given User logged in
		Given File is public
		When User adds tag
		Then status code is 200

	Scenario: User adds tags to private file while logged in
		Given User logged in
		Given File is private
		When User adds tag
		Then status code is 200

	Scenario: User deletes tags to public file while not logged in
		Given User not logged in
		Given File is public
		When User deletes tag
		Then status code is 200

	Scenario: User deletes tags to public file while logged in
		Given User logged in
		Given File is public
		When User deletes tag
		Then status code is 200

	Scenario: User deletes tags to private file while logged in
		Given User logged in
		Given File is private
		When User deletes tag
		Then status code is 200

	
