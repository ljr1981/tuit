note
	testing: "type/manual"

class
	TU_SOS_TEST_SET

inherit
	TEST_SET_SUPPORT

	TU_SOS
		undefine
			default_create
		end

feature -- Test routines

	SOS_test
			-- Test of `sos'
		note
			testing:
				"covers/{TU_SOS}.sos",
				"execution/isolated", "execution/serial"
		do
			set_silent
			my_feature_with_args (1776, True, "blah String", <<2001, False, Void, 'c'>>)
		end

	SOS_strings_equal_test
			-- Test of `sos_strings_equal'
		note
			testing:
				"covers/{TU_SOS}.sos_strings_equal",
				"execution/isolated", "execution/serial"
		do
			set_silent
			check sos_strings_equal (Current, ["this_string","is_not_this_string"]) end
		end

feature {NONE} -- Support

	my_feature_with_args (a: INTEGER; b: BOOLEAN; c: STRING; d: ARRAY [detachable ANY])
			-- A command routine with four arguments.
		require
			always_fails: sos (False, Current, "my_feature_with_args", ([a,b,c,d]))
		do
			-- we want the require to fail Soft or Silent (SOS)!
		end

	my_feature_no_args
			-- A command routine with no arguments.
		require
			test_precon_no_args: sos (False, Current, "my_feature_1", [])
		do
			do_nothing
		end

end


