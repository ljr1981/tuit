note
	testing: "type/manual"

class
	IN_SYSTEM_TEST_SET

inherit
	TEST_SET_SUPPORT

feature -- Test routines

	in_system
			-- New test routine
		note
			testing:  "covers/{ANY}.default_create", "execution/isolated", "execution/serial"
		do
			-- in-system.
		end

end

