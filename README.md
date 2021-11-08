# Tuit
Let's Get Tuit

## Introduction Tuit
In Eiffel, we can include some or all contract assertions in our final production binaries. The result of a broken contract is a broken program. It just stops, dumps a callstack, and exits. But what if we wanted to silently fail—sending messages, emails, or logging instead of just abject failure? In this case—we want to know about a contract failure, but we do not want it breaking our production application! Viola—let's do it with Tuit!

## SOS (Silent or Soft)
The SOS fail will not stop your program, but will log the failure. At the moment, failures are logged to a *.log file on the file system. A better solution is to send a log message to a logging server via UDP (e.g. Kiwi Syslog is a great example of doing this).

## JSON Capture
What you will not get is a call-stack. You will get much more!

## Example
Here is an example of what is presently being generated in test code in the Tuit library itself:
```
11/07/2021 7:22:03.403 PM - ERROR - string_starts_with
generating_type={TU_SOS_TEST_SET}
feature=string_not_starts_with
args=["starts_with_this","does_not"]
object={"$TYPE":"TU_SOS_TEST_SET","file_system":{"$TYPE":"EQA_FILE_SYSTEM","asserter":{"$TYPE":"EQA_ASSERTIONS","last_assertion_failed":false}},"environment":{"$TYPE":"EQA_ENVIRONMENT"},"internal_asserter":{"$TYPE":"EQA_ASSERTIONS","last_assertion_failed":false},"default_path":{"$TYPE":"PATH","storage":".\u0000\\\u0000t\u0000e\u0000s\u0000t\u0000i\u0000n\u0000g\u0000\\\u0000t\u0000e\u0000s\u0000t\u0000_\u0000o\u0000u\u0000t\u0000p\u0000u\u0000t\u0000\\\u0000s\u0000o\u0000s\u0000.\u0000l\u0000o\u0000g\u0000","internal_name":".\\testing\\test_output\\sos.log","is_normalized":true},"silent":true,"last_assertion_failed":false,"has_failed":false}
```

The generating test code is:
```
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
```

### Timestamp
The first line of the log entry is a time stamp title line. It is a typical Logging library entry and includes the type of log entry as well as a title that you control.

### Generating Type
The second line of the log entry is the generating type of the object where the contract failure happened. This is automatically generated using reflection.

### Feature Name
The third line is the feature name. You are responsible for this inforation. This means that if you do a rename of the feature, you will need to change the text in your sos-call. You might be able to avoid this manual labor during a rename if you enclose the feature name in `silly-quotes' (like that).

### Args (or other)
The fourth line of the log entry will generally be the arguments line. This consists of a key-value pair, such as: 

args=["starts_with_this","does_not"]

The right-hand side is a TUPLE where you can put whatever variables you like and only your creatively is your limit.

### Object
Finally, we have the Current object serialized to JSON. The purpose of this JSON representation of the failing object is manifold:

- It provides a clean and consistent way to capture the state of the object for easy review.
- It does mean that complex or data-laden objects will be potentially large and complicated. You will want to be thoughtful about what object you reference.
- As JSON, it provides a possible means of recreating an object in a failing-state, whereby one can create an appropriate and accurate failing test.

## Conclusion
The log messages are only generated on failure. Contracts that pass do not generate a log entry.

## PS
In order to have the SOS contracts in your production code, you will need to compile with some level of contracts turned on. This means that whatever code the Eiffel compiler generates will be present and whatever performance hit the code takes because of that will also be present. This is why having multiple versions of an executable is preferred. Perhaps someday that Eiffel compiler will now (for itself) how to generate SOS contracts in a very lean and efficient way such that contracts can be left on even in the most intense production environments.