import zenlog.Log;
import utest.ui.Report;
import utest.Assert;
import utest.Async;
import utest.Runner;
import yaku_core.test_utils.TestLog;

class TestsMain {
	public static function main() {
		TestLog.init();

		var runner = new Runner();
		runner.addCases(yaku_beta_test);
		runner.onTestStart.add(function(x) {
			TestLog.startTest(x.fixture.method);
		});
		runner.onTestComplete.add(function(x) {
			for (assert in x.results) {
				switch (assert) {
					case Failure(msg, pos):
						TestLog.debugForTest();
						break;
					case Error(e, stack):
						TestLog.debugForTest();
						break;
					default:
				}
			}
			TestLog.finishTest();
		});


		Report.create(runner);
		TestLog.ageWarning();
		runner.run();
	}
}
