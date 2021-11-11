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

	sos_assert (a_test_result: BOOLEAN; a_obj_ref: ANY; a_fail_msg: STRING; a_args: TUPLE): BOOLEAN
			-- SOS Assertion with `args'.
		require
			has_msg: not a_fail_msg.is_empty
		do
			if silent and not a_test_result then
				silent_fail ("not_sos", a_obj_ref, a_fail_msg, "args", a_args)
				Result := silent
			else
				Result := a_test_result or else not a_test_result
			end
		ensure
			sos_fail: silent and not a_test_result implies (Result = True)
			no_sos: not silent implies (Result or else not Result)
		end

	sos_string_starts_with (a_obj_ref: ANY; a_args: TUPLE): BOOLEAN
			-- SOS String starts with other in `args'.
		require
			has_target_and_starts_with: a_args.count >= 2
			has_test_string: attached {STRING} a_args [1]
			has_starts_with_string: attached {STRING} a_args [2]
		local
			l_result: BOOLEAN
		do
			check
				a_args.count >= 2 and then
					attached {STRING} a_args [1] as al_test_string and then
					attached {STRING} a_args [2] as al_starts_with
			then
				l_result := (al_test_string.count >= al_starts_with.count and then
								al_starts_with.same_string (al_test_string.substring (1, al_starts_with.count))) or else
							(al_starts_with.count >= al_test_string.count and then
								al_test_string.same_string (al_starts_with.substring (1, al_test_string.count)))
			end
			if silent and not l_result then
				silent_fail ("sos_string_not_starts_with", a_obj_ref, "sos_string_starts_with", "args", a_args)
				Result := silent
			else
				Result := l_result
			end
		end

	sos_strings_equal (a_obj_ref: ANY; a_args: TUPLE): BOOLEAN
			-- SOS Strings Equal Assertion with `args'.
		require
			has_target_and_test: a_args.count >= 2
			has_target: attached {STRING} a_args [1]
			has_test: attached {STRING} a_args [2]
		local
			l_result: BOOLEAN
		do
			check a_args.count >= 2 and then
				attached {STRING} a_args [1] as al_target and then
				attached {STRING} a_args [2] as al_test then
				l_result := al_test.same_string (al_target)
			end
			if silent and not l_result then
				silent_fail ("sos_strings_not_equal", a_obj_ref, "sos_strings_equal", "target_and_test", a_args)
				Result := silent
			else
				Result := l_result
			end
		end

	-- Potential sos-features ...

	sos_string_ends_with (a_obj_ref: ANY; a_args: TUPLE): BOOLEAN
			-- sos_string_ends_with
		require
			has_target_and_test: a_args.count >= 2
			has_target: attached {STRING} a_args [1]
			has_test: attached {STRING} a_args [2]
		local
			l_result: BOOLEAN
		do
			check a_args.count >= 2 and then
					attached {STRING} a_args [1] as al_target and then
					attached {STRING} a_args [2] as al_test and then
					attached al_target.count as al_end and then
					attached (al_end - al_test.count + 1) as al_start
			then
				l_result := (al_target.count >= al_test.count and then
								al_target.substring (al_start, al_end).same_string (al_test))
			end
			if silent and not l_result then
				silent_fail ("sos_not_string_ends_with", a_obj_ref, "sos_string_ends_with", "target_and_test", a_args)
				Result := silent
			else
				Result := l_result
			end
		end

	sos_string_contains (a_obj_ref: ANY; a_args: TUPLE): BOOLEAN
			-- sos_string_contains
		require
			has_target_and_test: a_args.count >= 2
			has_target: attached {STRING} a_args [1]
			has_test: attached {STRING} a_args [2]
		local
			l_result: BOOLEAN
		do
			check a_args.count >= 2 and then
					attached {STRING} a_args [1] as al_target and then
					attached {STRING} a_args [2] as al_test and then
					attached al_target.count as al_end and then
					attached (al_end - al_test.count + 1) as al_start
			then
				l_result := al_target.has_substring (al_test)
			end
			if silent and not l_result then
				silent_fail ("sos_not_string_contains", a_obj_ref, "sos_string_contains", "target_and_test", a_args)
				Result := silent
			else
				Result := l_result
			end
		end

	-- sos_string_has_n_instances

	sos_a_b_equal (a, b: ANY; a_obj_ref: ANY; a_args: TUPLE): BOOLEAN
			-- sos_a_b_equal
		local
			l_result: BOOLEAN
		do
			l_result := a.is_equal (b)
			if silent and not l_result then
				silent_fail ("sos_a_b_equal", a_obj_ref, "sos_a_b_not_equal", "args_and_a_and_b", a_args.plus ([a, b]))
				Result := silent
			else
				Result := l_result
			end
		end

	sos_a_less_than_b (a, b: ANY; a_obj_ref: ANY; a_args: TUPLE): BOOLEAN
			-- sos_a_less_than_b
		require
			same_type: a.same_type (b)
			comparable: attached {COMPARABLE} a and then attached {COMPARABLE} b
		local
			l_result: BOOLEAN
		do
			if attached {COMPARABLE} a as al_a and then attached {COMPARABLE} b as al_b then
				l_result := al_a.is_less (al_b)
				if silent and not l_result then
					silent_fail ("sos_a_less_than_b", a_obj_ref, "sos_a_not_less_than_b", "args_and_a_and_b", a_args.plus ([a, b]))
					Result := silent
				else
					Result := l_result
				end
			end
		end

	sos_a_greater_than_b (a, b: ANY; a_obj_ref: ANY; a_args: TUPLE): BOOLEAN
			-- sos_a_greater_than_b
		require
			same_type: a.same_type (b)
			comparable: attached {COMPARABLE} a and then attached {COMPARABLE} b
		local
			l_result: BOOLEAN
		do
			if attached {COMPARABLE} a as al_a and then attached {COMPARABLE} b as al_b then
				l_result := al_a.is_greater (al_b)
				if silent and not l_result then
					silent_fail ("sos_a_greater_than_b", a_obj_ref, "sos_a_not_greater_than_b", "args_and_a_and_b", a_args.plus ([a, b]))
					Result := silent
				else
					Result := l_result
				end
			end
		end

	sos_a_less_than_or_equal_to_b (a, b: ANY; a_obj_ref: ANY; a_args: TUPLE): BOOLEAN
			-- sos_a_less_than_or_equal_to_b
		require
			same_type: a.same_type (b)
			comparable: attached {COMPARABLE} a and then attached {COMPARABLE} b
		local
			l_result: BOOLEAN
		do
			if attached {COMPARABLE} a as al_a and then attached {COMPARABLE} b as al_b then
				l_result := al_a.is_less_equal (al_b)
				if silent and not l_result then
					silent_fail ("sos_a_less_than_or_equal_to_b", a_obj_ref, "sos_a_not_less_than_or_equal_to_b", "args_and_a_and_b", a_args.plus ([a, b]))
					Result := silent
				else
					Result := l_result
				end
			end
		end

	sos_a_greater_than_or_equal_to_b (a, b: ANY; a_obj_ref: ANY; a_args: TUPLE): BOOLEAN
			-- sos_a_greater_than_or_equal_to_b
		require
			same_type: a.same_type (b)
			comparable: attached {COMPARABLE} a and then attached {COMPARABLE} b
		local
			l_result: BOOLEAN
		do
			if attached {COMPARABLE} a as al_a and then attached {COMPARABLE} b as al_b then
				l_result := al_a.is_greater_equal (al_b)
				if silent and not l_result then
					silent_fail ("sos_a_not_greater_than_or_equal_to_b", a_obj_ref, "sos_a_greater_than_or_equal_to_b", "args_and_a_and_b", a_args.plus ([a, b]))
					Result := silent
				else
					Result := l_result
				end
			end
		end

	sos_a_in_range_inclusive (a, a_lower, a_upper: ANY; a_obj_ref: ANY; a_args: TUPLE): BOOLEAN
			-- sos_a_in_range_inclusive
		require
			comparable_a: attached {COMPARABLE} a
			comparable_lower: attached {COMPARABLE} a_lower
			comparable_upper: attached {COMPARABLE} a_upper
			same_types: attached {like a} a_lower and then attached {like a} a_upper
		local
			l_result: BOOLEAN
		do
			if attached {COMPARABLE} a as al_a and then
				attached {COMPARABLE} a_lower as al_lower and then
				attached {COMPARABLE} a_upper as al_upper and then
				attached {like a} al_lower and then
				attached {like a} al_upper
			then
				l_result := al_a.is_greater_equal (al_lower) and then
							al_a.is_less_equal (al_upper)
				if silent and not l_result then
					silent_fail ("sos_not_a_in_range_inclusive", a_obj_ref, "sos_a_in_range_inclusive", "a_lower_upper", a_args.plus ([a, a_lower, a_upper]))
					Result := silent
				else
					Result := l_result
				end
			end
		end

	sos_a_in_range_inclusive_left (a, a_lower, a_upper: ANY; a_obj_ref: ANY; a_args: TUPLE): BOOLEAN
			-- sos_a_in_range_inclusive_left
		require
			comparable_a: attached {COMPARABLE} a
			comparable_lower: attached {COMPARABLE} a_lower
			comparable_upper: attached {COMPARABLE} a_upper
			same_types: attached {like a} a_lower and then attached {like a} a_upper
		local
			l_result: BOOLEAN
		do
			if attached {COMPARABLE} a as al_a and then
				attached {COMPARABLE} a_lower as al_lower and then
				attached {COMPARABLE} a_upper as al_upper and then
				attached {like a} al_lower and then
				attached {like a} al_upper
			then
				l_result := al_a.is_greater_equal (al_lower) and then
							al_a.is_less (al_upper)
				if silent and not l_result then
					silent_fail ("sos_not_a_in_range_inclusive_left", a_obj_ref, "sos_a_in_range_inclusive_left", "args_and_a_and_b", a_args.plus ([a, a_lower, a_upper]))
					Result := silent
				else
					Result := l_result
				end
			end
		end

	sos_a_in_range_inclusive_right (a, a_lower, a_upper: ANY; a_obj_ref: ANY; a_args: TUPLE): BOOLEAN
			-- sos_a_in_range_inclusive_right
		require
			comparable_a: attached {COMPARABLE} a
			comparable_lower: attached {COMPARABLE} a_lower
			comparable_upper: attached {COMPARABLE} a_upper
			same_types: attached {like a} a_lower and then attached {like a} a_upper
		local
			l_result: BOOLEAN
		do
			if attached {COMPARABLE} a as al_a and then
				attached {COMPARABLE} a_lower as al_lower and then
				attached {COMPARABLE} a_upper as al_upper and then
				attached {like a} al_lower and then
				attached {like a} al_upper
			then
				l_result := al_a.is_greater (al_lower) and then
							al_a.is_less_equal (al_upper)
				if silent and not l_result then
					silent_fail ("sos_not_a_in_range_inclusive_right", a_obj_ref, "sos_a_in_range_inclusive_right", "args_and_a_and_b", a_args.plus ([a, a_lower, a_upper]))
					Result := silent
				else
					Result := l_result
				end
			end
		end

	sos_a_in_range_exclusive (a, a_lower, a_upper: ANY; a_obj_ref: ANY; a_args: TUPLE): BOOLEAN
			-- sos_a_in_range_exclusive
		require
			comparable_a: attached {COMPARABLE} a
			comparable_lower: attached {COMPARABLE} a_lower
			comparable_upper: attached {COMPARABLE} a_upper
			same_types: attached {like a} a_lower and then attached {like a} a_upper
		local
			l_result: BOOLEAN
		do
			if attached {COMPARABLE} a as al_a and then
				attached {COMPARABLE} a_lower as al_lower and then
				attached {COMPARABLE} a_upper as al_upper and then
				attached {like a} al_lower and then
				attached {like a} al_upper
			then
				l_result := al_a.is_greater (al_lower) and then
							al_a.is_less (al_upper)
				if silent and not l_result then
					silent_fail ("sos_not_a_in_range_exclusive", a_obj_ref, "sos_a_in_range_exclusive", "args_and_a_and_b", a_args.plus ([a, a_lower, a_upper]))
					Result := silent
				else
					Result := l_result
				end
			end
		end

	-- sos_a_out_of_range_inclusive
	-- sos_a_out_of_range_inclusive_left
	-- sos_a_out_of_range_inclusive_right

	-- sos_a_out_of_range_exclusive
	-- sos_a_out_of_range_exclusive_left
	-- sos_a_out_of_range_exclusive_right

	-- sos_a_in_set
	-- sos_set_has_a


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
