note
	description: "SOS (Soft or Silent) Contract Facilities"

class
	TU_SOS

inherit
	ANY_EXT

feature -- Access

	silent: BOOLEAN
			-- Is `silent' fail set?

feature -- Settings

	set_silent
			--
		do
			silent := True
		end

	reset_silent
			--
		do
			silent := False
		end

feature -- SOS assertions

	sos (a_test_result: BOOLEAN; a_obj_ref: ANY; a_fail_msg: STRING; a_args: TUPLE): BOOLEAN
			-- SOS Assertion with `args'.
		do
			if silent and not a_test_result then
				silent_fail ("precon_args", a_obj_ref, a_fail_msg, "args", a_args)
				Result := silent
			else
				Result := a_test_result or else not a_test_result
			end
		end

	sos_string_starts_with (a_obj_ref: ANY; a_args: TUPLE): BOOLEAN
			-- SOS String starts with other in `args'.
		require
			has_expected_and_actual: a_args.count >= 2
			has_as_strings_expected: attached {STRING} a_args [1]
			has_as_strings_actual: attached {STRING} a_args [2]
		local
			l_result: BOOLEAN
		do
			check
				a_args.count >= 2 and then
					attached {STRING} a_args [1] as item_expected and then
					attached {STRING} a_args [2] as item_actual
			then
				l_result := item_expected.count >= item_actual.count and then
							item_actual.same_string (item_expected.substring (1, item_actual.count))
			end
			if silent and not l_result then
				silent_fail ("string_starts_with", a_obj_ref, "string_not_starts_with", "args", a_args)
				Result := silent
			else
				Result := l_result
			end
		end

	sos_strings_equal (a_obj_ref: ANY; a_args: TUPLE): BOOLEAN
			-- SOS Strings Equal Assertion with `args'.
		require
			has_expected_and_actual: a_args.count >= 2
			has_as_strings_expected: attached {STRING} a_args [1]
			has_as_strings_actual: attached {STRING} a_args [2]
		local
			l_result: BOOLEAN
		do
			check a_args.count >= 2 and then attached {STRING} a_args [1] as item_expected and then attached {STRING} a_args [2] as item_actual then
				l_result := item_expected.same_string (item_actual)
			end
			if silent and not l_result then
				silent_fail ("stings_equal", a_obj_ref, "strings_not_equal", "expected_vs_actual", a_args)
				Result := silent
			else
				Result := l_result
			end
		end

feature {NONE} -- Implemenation: Basic Ops

	silent_fail (a_msg: STRING; a_obj_ref: ANY; a_fail_message, a_type: STRING; a_args: detachable TUPLE)
			-- Generically `silent_fail' with message `m' for object `o'.
			-- Include reference to feature name `f' of `a_type' and possible
			-- arguments or variables in `a_items'
		local
			l_msg: STRING
		do
			l_msg := a_msg
			l_msg.append_string_general ("%Ngenerating_type={" + a_obj_ref.generating_type + "}")
			l_msg.append_string_general ("%Nfeature=" + a_fail_message)
			l_msg.append_string_general ("%N" + a_type + "=[")
			if attached a_args as al_items then
				⟳ ic:al_items ¦
					if attached {ANY} ic as al_ic then
						l_msg.append_string_general (out_JSON_v (al_ic) + ",")
					end
				⟲
				if l_msg [l_msg.count] = ',' then
					l_msg.remove_tail (1)
				end
			end
			l_msg.append_character (']')
			l_msg.append_string_general ("%Nobject=" + out_JSON_v (a_obj_ref))
			logger.write_error (l_msg)
		end

feature {NONE} -- Implementation

	logger: LOG_LOGGING_FACILITY
			-- Basic Logging Facility
		once
			create Result.make
		end

	writer: LOG_ROLLING_WRITER_FILE
			-- Basic Log Writer
		once
			create Result.make_at_location (default_path)
			Result.enable_debug_log_level
		end

	default_path: PATH
			-- The `default_path' (Current) unless otherwise set.
		attribute
			create Result.make_current
		end

end
