package yaku_beta.dstruct;

class DoublyLinkedList<T> {
	private var h:DLListNode<T>;
	private var q:DLListNode<T>;

	/**
		The length of `this` List.
	**/
	public var length(default, null):Int;

	/**
		Creates a new empty list.
	**/
	public function new() {
		length = 0;
	}

	/**
		Adds element `item` at the end of `this` List.

		`this.length` increases by 1.
	**/
	public function add(item:T):DLListNode<T> {
		var x = new DLListNode<T>(item, null, q);
		if (h == null)
			h = x;
		else
			q.next = x;
		q = x;
		length++;
		return x;
	}

	public function insertAfter(node:DLListNode<T>, item:T) {
		var n = node.next;
		var x = new DLListNode<T>(item, n, node);
		n.prev = x;
		node.next = x;
		if (q == node) {
			q = x;
		}
		length++;
	}

	public function insertBefore(node:DLListNode<T>, item:T) {
		var p = node.prev;
		var x = new DLListNode<T>(item, node, p);
		if (p != null) {
			p.next = x;
		}
		node.prev = x;
		if (h == node) {
			h = x;
		}
		length++;
	}

	public function nodeOf(item:T):Null<DLListNode<T>> {
		for (node in nodeIterator()) {
			if (node.item == item) {
				return node;
			}
		}
		return null;
	}

	/**
		Adds element `item` at the beginning of `this` List.

		`this.length` increases by 1.
	**/
	public function push(item:T) {
		if (h == null) {
			add(item);
		} else {
			insertBefore(h, item);
		}
	}

	/**
		Returns the first element of `this` List, or null if no elements exist.

		This function does not modify `this` List.
	**/
	public function first():Null<DLListNode<T>> {
		return h;
	}

	/**
		Returns the last element of `this` List, or null if no elements exist.

		This function does not modify `this` List.
	**/
	public function last():Null<DLListNode<T>> {
		return q;
	}

	/**
		Returns the first element of `this` List, or null if no elements exist.

		The element is removed from `this` List.
	**/
	public function pop():Null<DLListNode<T>> {
		if (h == null)
			return null;
		var x = h;
		removeNode(h);
		return x;
	}

	/**
		Tells if `this` List is empty.
	**/
	public function isEmpty():Bool {
		return (h == null);
	}

	/**
		Empties `this` List.

		This function does not traverse the elements, but simply sets the
		internal references to null and `this.length` to 0.
	**/
	public function clear():Void {
		h = null;
		q = null;
		length = 0;
	}

	/**
		Removes the first occurrence of `v` in `this` List.

		If `v` is found by checking standard equality, it is removed from `this`
		List and the function returns true.

		Otherwise, false is returned.
	**/
	public function remove(v:T):Bool {
		var n = nodeOf(v);
		if (n == null) {
			return false;
		}
		removeNode(n);
		return true;
	}

	public function removeNode(n:DLListNode<T>) {
		if (h == n) {
			h = n.next;
		} else if (q == n) {
			q = n.prev;
		}
		var prev = n.prev;
		var next = n.next;
		if (prev != null) {
			prev.next = next;
		}
		if (next != null) {
			next.prev = prev;
		}
		length--;
	}

	/**
		Returns an iterator on the elements of the list.
	**/
	public inline function iterator():DLListIterator<T> {
		return new DLListIterator<T>(h);
	}

	/**
		Returns an iterator of the List indices and values.
	**/
	@:pure @:runtime public inline function keyValueIterator():DLListKeyValueIterator<T> {
		return new DLListKeyValueIterator(h);
	}

	/**
		Returns an iterator on the elements of the list.
	**/
	public inline function nodeIterator():DLListNodeIterator<T> {
		return new DLListNodeIterator<T>(h);
	}

	/**
		Returns a string representation of `this` List.

		The result is enclosed in { } with the individual elements being
		separated by a comma.
	**/
	public function toString() {
		var s = new StringBuf();
		var first = true;
		var l = h;
		s.add("{");
		while (l != null) {
			if (first)
				first = false;
			else
				s.add(", ");
			s.add(Std.string(l.item));
			l = l.next;
		}
		s.add("}");
		return s.toString();
	}

	/**
		Returns a string representation of `this` List, with `sep` separating
		each element.
	**/
	public function join(sep:String) {
		var s = new StringBuf();
		var first = true;
		var l = h;
		while (l != null) {
			if (first)
				first = false;
			else
				s.add(sep);
			s.add(l.item);
			l = l.next;
		}
		return s.toString();
	}

	/**
		Returns a list filtered with `f`. The returned list will contain all
		elements for which `f(x) == true`.
	**/
	public function filter(f:T->Bool) {
		var l2 = new DoublyLinkedList();
		var l = h;
		while (l != null) {
			var v = l.item;
			l = l.next;
			if (f(v))
				l2.add(v);
		}
		return l2;
	}

	/**
		Returns a new list where all elements have been converted by the
		function `f`.
	**/
	public function map<X>(f:T->X):DoublyLinkedList<X> {
		var b = new DoublyLinkedList();
		var l = h;
		while (l != null) {
			var v = l.item;
			l = l.next;
			b.add(f(v));
		}
		return b;
	}
}

@:allow(yaku_beta.dstruct.DoublyLinkedList)
class DLListNode<T> {
	public var item:T;
	public var next(default, null):Null<DLListNode<T>>;
	public var prev(default, null):Null<DLListNode<T>>;

	private function new(item:T, next:Null<DLListNode<T>>, prev:Null<DLListNode<T>>) {
		this.item = item;
		this.next = next;
		this.prev = prev;
	}

	public function replace(item:T) {
		this.item = item;
	}
}

private class DLListIterator<T> {
	var head:DLListNode<T>;

	public inline function new(head:DLListNode<T>) {
		this.head = head;
	}

	public inline function hasNext():Bool {
		return head != null;
	}

	public inline function next():T {
		var val = head.item;
		head = head.next;
		return val;
	}
}

private class DLListNodeIterator<T> {
	var head:DLListNode<T>;

	public inline function new(head:DLListNode<T>) {
		this.head = head;
	}

	public inline function hasNext():Bool {
		return head != null;
	}

	public inline function next():DLListNode<T> {
		var val = head;
		head = head.next;
		return val;
	}
}

private class DLListKeyValueIterator<T> {
	var idx:Int;
	var head:DLListNode<T>;

	public inline function new(head:DLListNode<T>) {
		this.head = head;
		this.idx = 0;
	}

	public inline function hasNext():Bool {
		return head != null;
	}

	public inline function next():{key:Int, value:DLListNode<T>} {
		var val = head;
		head = head.next;
		return {value: val, key: idx++};
	}
}
