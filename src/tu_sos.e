note
	description: "SOS (Soft or Silent) Contract Facilities"

class
	TU_SOS

inherit
	ANY_EXT

feature -- Access

	silent: BOOLEAN

feature -- Settings

	set_silent
			--
		do
			silent := True
		end

feature -- Require Preconditions

	pre (passing: BOOLEAN; o: ANY; f: STRING): BOOLEAN
			-- Precondition without arguments.
		do
			if silent and not passing then
				silent_fail ("precon", o, f, "routine", Void)
				Result := silent
			else
				Result := passing
			end
		end

	pre_args (passing: BOOLEAN; o: ANY; f: STRING; args: TUPLE): BOOLEAN
			-- Preconditions with `args'.
		do
			if silent and not passing then
				silent_fail ("precon_args", o, f, "args", args)
				Result := silent
			else
				Result := passing or else not passing
			end
		end

feature -- Check Conditions

	check_ (passing: BOOLEAN; o: ANY; f: STRING): BOOLEAN
			-- Check condition without variables.
		do
			if silent and not passing then
				silent_fail ("check", o, f, "sequence", Void)
				Result := silent
			else
				Result := passing or else not passing
			end
		end

	check_v (passing: BOOLEAN; o: ANY; f: STRING; vars: TUPLE): BOOLEAN
			-- Check condition with variables list.
		do
			if silent and not passing then
				silent_fail ("check", o, f, "sequence", vars)
				Result := silent
			else
				Result := passing or else not passing
			end
		end

feature -- Check Conditions

	post (passing: BOOLEAN; o: ANY; f: STRING): BOOLEAN
			-- Ensure condition on Command.
		do
			if silent and not passing then
				silent_fail ("postcon", o, f, "command", Void)
				Result := silent
			else
				Result := passing or else not passing
			end
		end

	post_r (passing: BOOLEAN; o: ANY; f: STRING; r: detachable ANY): BOOLEAN
			-- Ensure post-condition on Query with Results in `r'.
		do
			if silent and not passing then
				silent_fail ("check", o, f, "query", [r])
				Result := silent
			else
				Result := passing or else not passing
			end
		end

feature {NONE} -- Implemenation: Basic Ops

	silent_fail (m: STRING; o: ANY; f, a_type: STRING; a_items: detachable TUPLE)
			-- Generically `silent_fail' with message `m' for object `o'.
			-- Include reference to feature name `f' of `a_type' and possible
			-- arguments or variables in `a_items'
		local
			l_msg: STRING
		do
			l_msg := m
			l_msg.append_string_general ("%Ngenerating_type={" + o.generating_type + "}")
			l_msg.append_string_general ("%Nfeature=" + f)
			l_msg.append_string_general ("%N" + a_type + "=[")
			if attached a_items as al_items then
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
			l_msg.append_string_general ("%Nobject=" + out_JSON_v (o))
			logger.write_error (l_msg)
		end

feature {NONE} -- Implementation

	logger: LOG_LOGGING_FACILITY
			-- Basic Logging Facility
		once
			create Result.make
			Result.enable_default_file_log
		end

	writer: LOG_WRITER_FILE
			-- Basic Log Writer
		once
			create Result
			Result.enable_debug_log_level
		end

end
