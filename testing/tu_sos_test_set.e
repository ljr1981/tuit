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

	precondition_with_args_test
			-- Test of `pre_args'
		note
			testing:
				"covers/{TU_SOS}.precondition_with_args",
				"execution/isolated", "execution/serial"
		do
			set_silent
			my_feature_with_args (1776, True, "blah String", <<2001, False, Void, 'c'>>)
		end

feature {NONE} -- Support

	my_feature_with_args (a: INTEGER; b: BOOLEAN; c: STRING; d: ARRAY [detachable ANY])
			-- A command routine with four arguments.
		require
			always_fails: pre_args (False, Current, "my_feature_with_args", ([a,b,c,d]))
		do
			-- we want the require to fail soft or silent!
		end

	my_feature_no_args
			-- A command routine with no arguments.
		require
			test_precon_no_args: pre (False, Current, "my_feature_1")
		do
			do_nothing
		end

end


