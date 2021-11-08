﻿note
	testing: "type/manual"

class
	TU_SOS_TEST_SET

inherit
	TEST_SET_SUPPORT
		redefine
			on_prepare
		end

	TU_SOS
		undefine
			default_create
		end

feature {NONE} -- Initialization

	testing_output: STRING
		once
			Result := (create {OPERATING_ENVIRONMENT}).current_directory_name_representation + "\testing\test_output"
		end

	testing_output_dir: DIRECTORY
		once
			create Result.make_with_path (create {PATH}.make_from_string (testing_output))
		end

	on_prepare
			--<Precursor>
		do
			create default_path.make_from_string (testing_output + "\sos.log")
			testing_output_dir.delete_content
			logger.register_log_writer (writer)
			logger.write_notice ("TU_SOS_TEST_SET.on_prepare")
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
			reset_silent
			check sos_strings_equal (Current, ["this_string", "this_string"]) end
		end

	SOS_string_starts_with_test
			--
		note
			testing:
				"covers/{TU_SOS}.sos_string_starts_with",
				"execution/isolated", "execution/serial"
		do
			set_silent
			check sos_string_starts_with (Current, ["starts_with_this", "starts_with"]) end
			check sos_string_starts_with (Current, ["starts_with_this", "does_not"]) end

			reset_silent
			check sos_string_starts_with (Current, ["starts_with_this", "starts_with"]) end
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


