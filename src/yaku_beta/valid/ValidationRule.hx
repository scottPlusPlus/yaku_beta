package yaku_beta.valid;

import haxe.ds.ReadOnlyArray;

abstract ValidationRule<T> (ValidationEnum<T>) from ValidationEnum<T> {

  @:from inline static function fromLazyValidator<T>(x:T->String->Validation<T>):ValidationRule<T> {
    return ValidationEnum.LazyValidation(x);
  }

  @:from inline static function fromLazyErrors<T>(x:T->String->ReadOnlyArray<String>):ValidationRule<T> {
    return ValidationEnum.LazyErrors(x);
  }

  @:from inline static function fromReadyValidator<T>(x:Validation<T>):ValidationRule<T> {
    return ValidationEnum.ReadyValidation(x);
  }

  @:from inline static function fromReadyErrors<T>(x:ReadOnlyArray<String>):ValidationRule<T> {
    return ValidationEnum.ReadyErrors(x);
  }

  public function errors(value:T, name:String) :ReadOnlyArray<String> {
    switch(this){
        case LazyValidation(x):
            return x(value, name).errors();
        case  LazyErrors(x):
            return x(value, name);
        case ReadyValidation(x):
            return x.errors();
        case ReadyErrors(x):
            return x;
    }
  }

}

enum ValidationEnum<T> {
    LazyValidation(v:T->String->Validation<T>);
    LazyErrors(v:T->String->ReadOnlyArray<String>);
    ReadyValidation(v:Validation<T>);
    ReadyErrors(v:ReadOnlyArray<String>);
}
