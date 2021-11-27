package yaku_beta_test.valid1;

import yaku_beta.valid1.StringValidator;
import yaku_beta.valid1.Validator;
import utest.Assert;

using yaku_core.NullX;

class ValidatorTest extends utest.Test {
	function testNulls() {
		var v = new Validator<Int>("num");
		Assert.isFalse(v.isValid(null));

		v.allowNull = true;
		Assert.isTrue(v.isValid(null));
	}

// function validator(gallery:Gallery):Validator<Gallery> {
//     var v = new Validator<Gallery>("Gallery");
//     var ruleTitle = new StringValidator("Title").minLength(3).maxLength(128).asRule(function(gallery:Gallery) {
//         return gallery.title;
//     });
//     var ruleDescription = new StringValidator("Description").minLength(3).maxLength(128).asRule(function(gallery:Gallery) {
//         return gallery.description;
//     });
//     v.addRules([ruleTitle, ruleDescription]);
//     return v;
// }

// function handleCreateGalleryCommand(command:CreateGalleryRequest):Promise<Noise> {
// 	var gallery = command.gallery;
// 	var errors = Gallery.validator().validate(gallery);
// 	if (errors.length != 0){
// 		...
// 	}
// }

// function handleCreateGalleryCommand(command:CreateGalleryRequest):Promise<Noise> {
// 	var gallery = command.gallery;
// 	Gallery.validation(gallery).asOutcome().next( ...
// }


// if (gallery.description.length > 512){
// 	return "Description is too long";
// }
// if (gallery.title.length < 3 || gallery.title.length > 128){
// 	return "An error!";
// }


	function testUsage() {
		Assert.pass();
		var foo = new FooClass();
		foo.str = "hello";
		foo.num = 5;
		foo.child = new FooClass();

		var strV = new StringValidator("str").minLength(3).maxLength(7).asRule(function(obj) {
			return obj.str;
		});
		var numV = new Validator<Int>("num");

		/*
			var v = new Validator<FooClass>("foo").addRule(
				new StringValidator("str").minLength(3).maxLength(7).asRule(function(obj){ return obj.str;})
				new Validator<Int>("num").minVal(0).asRule(function(obj){ return obj.str;})
			);

			var strV = new StringValidator("str").minLength(3).maxLength(7);
			var v = new Validator().addRule(function(obj){
				return [
				   strV.errors(obj.str)
				]
			});



			var v = new Validator().addRule(function(obj){
				return [
					new StringValidator("str").minLength(3).maxLength(7).errors(obj.str)
				]
			})

			var v = new Validator().addRule(function(obj){
				return [
					Validator.of(obj.str).minChar(3).maxChar(7),
				]
			})

			var v = new Validator().assert(function(obj){
				return [
					Validator<String>(obj.str).minLength(3).maxLength(5)
					Validator<Foo>(obj.child).
				]
			})


			static function validate(g:Gallery) {
				var v = new Validation("Gallery"); //effectively just an Array<String> ??
				v.assertThat(g.title).minChar(3).maxChar(123);
				v.assertThat(g.description).contains("foo");
				v.also(g.child).rule(Gallery.validate)
				return v;
			}

			=> errCollection
		 */
	}
}

class FooClass {
	public var str:String;
	public var num:Int;
	public var child:FooClass;

	public function new() {}
}

// class Gallery {
// 	public var id:UUID;
// 	public var title:String;
// 	public var description:String;

// 	public var owners:Array<UserId>;
// 	public var contributes:Array<UserId>;

// 	public var items:Array<GalleryItem>;

// 	public var created:Timestamp;
// 	public var updated:Timestamp;

// 	public function new() {}
// }
