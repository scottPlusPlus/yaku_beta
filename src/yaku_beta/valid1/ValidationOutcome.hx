package yaku_beta.valid1;

enum ValidationOutcome {
	Pass();
	Fail(errors:Array<String>);
	FailAndExit(errors:Array<String>);
}