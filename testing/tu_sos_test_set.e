note
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
			my_feature_no_args
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

	SOS_string_ends_with_test
			-- SOS_string_ends_with_test
		note
			testing:
				"covers/{TU_SOS}.sos_string_ends_with",
				"execution/isolated", "execution/serial"
		do
			set_silent
			assert_booleans_equal ("ends_with_1", True, sos_string_ends_with (Current, ["string ends with", "ends with"]))
			assert_booleans_equal ("ends_with_2", True, sos_string_ends_with (Current, ["string ends with", "not ends with"]))

			reset_silent
			assert_booleans_equal ("ends_with_3", True, sos_string_ends_with (Current, ["string ends with", "ends with"]))
			assert_booleans_equal ("ends_with_4", False, sos_string_ends_with (Current, ["string ends with", "not ends with"]))

		end

	SOS_string_contains_test
			-- SOS_string_contains_test
		note
			testing:
				"covers/{TU_SOS}.SOS_string_contains",
				"execution/isolated", "execution/serial"
		do
			set_silent
			assert_booleans_equal ("ends_with_1", True, SOS_string_contains (Current, ["string ends with", "ends with"]))
			assert_booleans_equal ("ends_with_2", True, SOS_string_contains (Current, ["string ends with", "not ends with"]))

			reset_silent
			assert_booleans_equal ("ends_with_3", True, SOS_string_contains (Current, ["string ends with", "ends with"]))
			assert_booleans_equal ("ends_with_4", False, SOS_string_contains (Current, ["string ends with", "not ends with"]))

		end

	SOS_string_starts_with_test
			-- SOS_string_starts_with_test
		note
			testing:
				"covers/{TU_SOS}.sos_string_starts_with",
				"execution/isolated", "execution/serial"
		do
			set_silent
			assert_booleans_equal ("starts_with_1", True, sos_string_starts_with (Current, ["starts_with_this", "starts_with"]))
			assert_booleans_equal ("starts_with_2", True, sos_string_starts_with (Current, ["starts_with_this", "does_not"]))

			reset_silent
			assert_booleans_equal ("starts_with_3", True, sos_string_starts_with (Current, ["starts_with_this", "starts_with"]))
			assert_booleans_equal ("starts_with_4", True, sos_string_starts_with (Current, ["starts_with", "starts_with"]))
			assert_booleans_equal ("starts_with_5", True, sos_string_starts_with (Current, ["starts_with", "starts_with_more"]))
		end

	SOS_a_in_range_inclusive_test
			-- SOS_a_in_range_inclusive_test
		note
			testing:
				"covers/{TU_SOS}.SOS_a_in_range_inclusive",
				"execution/isolated", "execution/serial"
		do
			set_silent
			assert_booleans_equal ("starts_with_integer_50", True, SOS_a_in_range_inclusive (50, 0, 100, Current, []))
			assert_booleans_equal ("starts_with_integer_minus_50", True, SOS_a_in_range_inclusive (-50, 0, 100, Current, []))

			reset_silent
			assert_booleans_equal ("starts_with_integer_minus_50_not_silent", False, SOS_a_in_range_inclusive (-50, 0, 100, Current, []))
		end

feature {NONE} -- Support

	my_feature_with_args (a: INTEGER; b: BOOLEAN; c: STRING; d: ARRAY [detachable ANY])
			-- A command routine with four arguments.
		require
			always_fails: sos_assert (False, Current, "my_feature_with_args", ([a,b,c,d]))
		do
			-- we want the require to fail Soft or Silent (SOS)!
		end

	my_feature_no_args
			-- A command routine with no arguments.
		require
			test_precon_no_args: sos_assert (False, Current, "my_feature_no_args", [])
		do
			do_nothing
		end

end


