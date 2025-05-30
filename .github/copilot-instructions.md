###### Style guidelines

* Indent with tabs
* Never use camel case
* For functions, classes, methods, JavaScript\typescript literal objects, and typescript interfaces, use pascal case.
* For variables, class properties or function arguments: if the name is one word: use lowercase, two words: pascal case, more than two: snake case.
* Variables that refer to a function follow functions naming conventions.
* For keys in JavaScript\typescript literal objects, Python dictionaries, or typescript interfaces, use Pascal case. Don't enclose JavaScript\typescript keys in quotes unless you're accessing imported code, and the key has characters that can't be used without quotes.
* Aways prefer single quotes for strings
* Never put HTML block characters: "<", ">", "/>" on a new line.
* Be explicit when you add a React.Fragment: use: \<Fragment\>, not <>.
* ON c++\javascript\typescript ise /* comment */ instead of // comment
* Write human readable code, be explicit, the code funtionality must be evident, without clever constructs
* When writing react components use this syntax to declare arguments:
  ({ arg } : { arg: arg_type }).
* Indent assignments in consecutive lines, so the level of the operator and the value are the same: e.g.:
  let some_var    = 'Somevalue'
  let another_var = 'Another value
  consider this for any assignment: : = += and so on...
* On typesscript "cast" types to any whenver necessary 

###### Design

* Never directly access databases, files, global variables, cookies or local storage. Use the appropriate wrapper function instead. If one is needed and not implemented, advise that it should be, and don't modify or add any new code. This rule can be ignored if you're asked to implement  such  a wrapper function.
* Where pertinent, if a RESULT enum is defined, define functions to return a tuple, and return:

[RESULT.OK, FunctionResult]          // Function succeeded
[RESULT.FAILED, "Error description"] // Error

or, if the enum is not defined

["S_OK", FunctionResult]     // Function succeeded
["Err", "Error description"] // Error


As the FunctionResult won't necessarily be a string, declare the function return type to account for that. On c++, just use a 3rd element for FunctionResult and the 2nd for error
* If a RESULT enum is defined, use instead of "S_OK" and "Err"
* Aways parametrize database queries
* Don't nest code, except functions and only if it's not called from any other functions but the one it is nested in
* If a function called by only one function: nest it. Prefer nested funtions to classes with private methods
* Don't ever declare props to use a react components input: always use indenpendent arguments

###### Code generation

* Write ONLY what you're told to. The code you're being asked to write, whether it is a function, method, class, or react component, might be just a stub whose full functionality will be added later. Therefore, don't get ahead of yourself and write functionality you were not asked. Write strictly what you're told.
* If asked to modify an existing function, method, class, or react component, restrict your editions and additions to the body of the respective function, method, class, or component, except in the case of any necessary import. If it's not possible to implement what is asked without external edits, just advise, and do not modify anything.
* On JavaScript\typescript, if a map, filter or reduce statement spawns more than one line, just use a loop instead.
* if you're asked to modify some code. Never on your reply, replace unmodified code with comments. Return the entire code. ENTIRE code. with both new\modified and unmodified code
and old/unmodified code
