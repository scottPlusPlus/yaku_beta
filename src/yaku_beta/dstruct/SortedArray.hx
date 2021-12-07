package yaku_beta.dstruct;

import haxe.iterators.ArrayKeyValueIterator;
import haxe.iterators.ArrayIterator;

/*
* An Array that is sorted.  Inserts done using binary search
*/
class SortedArray<T> {
	final arr:Array<T>;
	final compare:(T, T) -> Int;

    public var length(get,never):Int;
    public function get_length():Int {
        return arr.length;
    }

	public function new(arr:Array<T>, compare:(T, T) -> Int) {
		this.arr = arr;
		this.compare = compare;
		arr.sort(compare);
	}

	public function contains(val:T):Bool {
		return arr.contains(val);
	}

	public function copy():SortedArray<T> {
		return new SortedArray(arr, compare);
	}

	public function filter(f:T->Bool):Array<T> {
		return arr.filter(f);
	}

	public function indexOf(val:T, ?fromIndex:Null<Int>):Int {
		// TODO - can make faster
		return arr.indexOf(val, fromIndex);
	}

    public function insert(val:T) {
		var index = binarySearch(arr, val, 0, arr.length - 1);
		arr.insert(index, val);
	}

	public function iterator():ArrayIterator<T> {
		return arr.iterator();
	}

	public function join(sep:String):String {
		return arr.join(sep);
	}

	public function keyValueIterator():ArrayKeyValueIterator<T> {
		return arr.keyValueIterator();
	}

    public function lastIndexOf(val:T, ?fromIndex:Int):Int {
        return arr.lastIndexOf(val, fromIndex);
    }

    public function map<S>(f:T -> S):Array<S> {
        return arr.map(f);
    }

    public function pop():Null<T> {
        return arr.pop();
    }

    public function remove(x:T):Bool  {
        //TODO - can make faster
        return arr.remove(x);
    }

    public function shift():Null<T>{
        return arr.shift();
    }

    public function slice(pos:Int, ?end:Int):Array<T> {
        return arr.slice(pos, end);
    }

    public function toString():String {
        return arr.toString();
    }

	private function binarySearch(arr:Array<T>, val:T, start:Int, end:Int):Int {
		if (start == end) {
			return start;
		}
		var mid = Std.int(start + (end - start) / 2);
		var midVal = arr[mid];
		var c = compare(val, midVal);
		if (c < 0) {
			return binarySearch(arr, val, start, mid);
		} else if (c > 0) {
			return binarySearch(arr, val, mid, end);
		} else {
			return mid;
		}
	}
}
