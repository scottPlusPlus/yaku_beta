package yaku_beta.valid;

import haxe.ds.ReadOnlyArray;

abstract Validation<T> (ValidationEnum<T>) from ValidationEnum<T> {

  @:from inline static function fromLazyValidator<T>(x:T->String->Validator<T>):Validation<T> {
    return ValidationEnum.LazyValidator(x);
  }

  @:from inline static function fromLazyErrors<T>(x:T->String->ReadOnlyArray<String>):Validation<T> {
    return ValidationEnum.LazyErrors(x);
  }

  @:from inline static function fromReadyValidator<T>(x:Validator<T>):Validation<T> {
    return ValidationEnum.ReadyValidator(x);
  }

  @:from inline static function fromReadyErrors<T>(x:ReadOnlyArray<String>):Validation<T> {
    return ValidationEnum.ReadyErrors(x);
  }

  public function errors(value:T, name:String) :ReadOnlyArray<String> {
    switch(this){
        case LazyValidator(x):
            return x(value, name).errors();
        case  LazyErrors(x):
            return x(value, name);
        case ReadyValidator(x):
            return x.errors();
        case ReadyErrors(x):
            return x;
    }
  }

}

enum ValidationEnum<T> {
    LazyValidator(v:T->String->Validator<T>);
    LazyErrors(v:T->String->ReadOnlyArray<String>);
    ReadyValidator(v:Validator<T>);
    ReadyErrors(v:ReadOnlyArray<String>);
}
