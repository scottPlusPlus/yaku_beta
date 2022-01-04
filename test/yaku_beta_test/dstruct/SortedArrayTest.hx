package yaku_beta_test.dstruct;

import zenlog.LogSplitter;
import zenlog.LogTester;
import yaku_beta.dstruct.SortedArray;
import zenlog.Log;
import utest.Assert;
import yaku_core.CommonSorters;

using yaku_core.NullX;

class SortedArrayTest extends utest.Test {
	function testIndexOf() {
		indexOfTests([0, 1, 2, 3, 4, 5], CommonSorters.intsAscending, [-5, 10]);
		indexOfTests([2, 4, 6, 8], CommonSorters.intsAscending, [0, 1, 3, 5, 7, 9]);

		var s = new SortedArray([1, 1, 1, 2, 2, 2, 3, 3, 3], CommonSorters.intsAscending, true);
		Assert.equals(0, s.indexOf(1));
		Assert.equals(2, s.lastIndexOf(1));
		Assert.equals(3, s.indexOf(2));
		Assert.equals(5, s.lastIndexOf(2));
		Assert.equals(6, s.indexOf(3));
		Assert.equals(8, s.lastIndexOf(3));
	}

	private function indexOfTests<T>(input:Array<T>, compare:T->T->Int, nonValues:Array<T>) {
		var sorted = new SortedArray(input, compare, false);
		var copy = sorted.copyArray();
		for (index in 0...copy.length) {
			var val = copy[index];
			Assert.equals(index, sorted.indexOf(val));
		}
		for (nv in nonValues) {
			Assert.equals(-1, sorted.indexOf(nv));
		}
	}

	function testInsert() {
		insertionTest([2, 4, 6, 8, 10], 1, CommonSorters.intsAscending);
		insertionTest([2, 4, 6, 8, 10], 3, CommonSorters.intsAscending);
		insertionTest([2, 4, 6, 8, 10], 5, CommonSorters.intsAscending);
		insertionTest([2, 4, 6, 8, 10], 11, CommonSorters.intsAscending);
		insertionTest([2, 4, 6, 8], 5, CommonSorters.intsAscending);
		insertionTest([2, 4, 6, 8], 2, CommonSorters.intsAscending);
		insertionTest([2, 4, 6, 8], 4, CommonSorters.intsAscending);
		insertionTest([], 10, CommonSorters.intsAscending);
	}

	private function insertionTest<T>(input:Array<T>, insertion:T, compare:T->T->Int) {
		var expected = input.copy();
		expected.push(insertion);
		expected.sort(compare);

		var sorted = new SortedArray(input, compare, false);
		sorted.insert(insertion);
		var actual = sorted.copyArray();
		var pass = Assert.same(expected, actual);
		if (!pass) {
			Log.debug('expected: $expected');
			Log.debug('actual: $actual');
		}
	}

	function testErrorOnUnsorted() {
		var mainLogger = Log.Logger;
		var logTester = new LogTester();
		var splitter = new LogSplitter();
		splitter.loggers = [mainLogger, logTester];
		Log.Logger = splitter;

		var input = [1, 10, 3];
		var sorted = new SortedArray(input, CommonSorters.intsAscending, true);
		var foundError = false;
		for (err in logTester.errorData) {
			if (err.message == "Array data is not pre-sorted") {
				foundError = true;
				break;
			}
		}
		Log.Logger = mainLogger;
		Assert.isTrue(foundError);
	}
}
