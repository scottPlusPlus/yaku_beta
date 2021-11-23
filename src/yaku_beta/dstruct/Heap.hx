package yaku_beta.dstruct;

class Heap<T> {
	public var length(default, null):UInt;

	private var data:Array<Null<T>> = [];

	private final compare:T->T->Int;

	public function new(compare:T->T->Int) {
		this.compare = compare;
		this.length = 0;
		var initSize = 9;
		data = [];
		data.resize(initSize);
	}

	public function peek():Null<T> {
		if (length == 0) {
			return null;
		}
		return data[0];
	}

	// returns and removes topmost
	public function pop():Null<T> {
		if (length == 0) {
			return null;
		}
		var val = data[1];
		data[1] = data[length];
		data[length] = null;
		length--;
		sink(1);
		return val;
	}

	public function push(x:T) {
		if (data.length == length) {
			resize();
		}
		data[length + 1] = x;
		length++;
		swim(length);
	}

	private function resize() {
		data.resize(length * 2);
	}

	public function toString():String {
		var str = "[";
		for (i in data) {
			str += Std.string(i) + ", ";
		}
		str += "]";
		return str;
	}

	private function swim(pos:Int) {
		if (pos == 1) {
			return;
		}
		var parentPos = parentIndex(pos);
		var val = data[pos];
		var parentVal = data[parentPos];
		if (doCompare(val, parentVal) < 0) {
			swap(pos, parentPos);
			swim(parentPos);
		}
	}

	private function sink(pos:Int) {
		var leftPos = leftChildIndex(pos);
		if (leftPos > data.length) {
			return;
		}
		var rightPos = rightChildIndex(pos);
		var valLeft = data[leftPos];
		var valRight = data[rightPos];

		var smallerVal = valLeft;
		var smallerPos = leftPos;
		if (doCompare(valLeft, valRight) > 0) {
			smallerVal = valRight;
			smallerPos = rightPos;
		}
		if (smallerVal == null) {
			return;
		}

		var val = data[pos];
		if (doCompare(smallerVal, val) < 0) {
			swap(pos, smallerPos);
			sink(smallerPos);
		}
	}

	private inline function swap(posX:Int, posY:Int) {
		var valX = data[posX];
		var valY = data[posY];

		data[posX] = valY;
		data[posY] = valX;
	}

	private inline function parentIndex(pos:Int):Int {
		if (pos == 1) {
			return null;
		}
		return Math.floor(pos / 2);
	}

	private inline function leftChildIndex(pos:Int):Int {
		return pos * 2;
	}

	private inline function rightChildIndex(pos:Int):Int {
		return pos * 2 + 1;
	}

	/*
	 * 1 means left is bigger.  -1 means left is smaller
	 */
	private inline function doCompare(valX:Null<T>, valY:Null<T>):Int {
		if (valX == null) {
			return 1;
		}
		if (valY == null) {
			return -1;
		}
		return compare(valX, valY);
	}
}
