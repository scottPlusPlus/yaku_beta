package yaku_beta.valid;

enum ValidationOutcome {
	Pass();
	Fail(errors:Array<String>);
	FailAndExit(errors:Array<String>);
}