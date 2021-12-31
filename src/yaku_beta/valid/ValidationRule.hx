package yaku_beta.valid;

import haxe.ds.ReadOnlyArray;

abstract ValidationRule<T> (ValidationEnum<T>) from ValidationEnum<T> {

  @:from inline static function fromLazyValidation<T>(x:T->String->Validation<T>):ValidationRule<T> {
    return ValidationEnum.LazyValidation(x);
  }

  @:from inline static function fromReadyValidation<T>(x:Validation<T>):ValidationRule<T> {
    return ValidationEnum.ReadyValidation(x);
  }

  @:from inline static function fromLazyErrors<T>(x:T->String->ReadOnlyArray<String>):ValidationRule<T> {
    return ValidationEnum.LazyErrors(x);
  }

  @:from inline static function fromLazyErrorsNameless<T>(x:T->ReadOnlyArray<String>):ValidationRule<T> {
    return ValidationEnum.LazyErrorsNameless(x);
  }


  public function errors(value:T, name:String) :ReadOnlyArray<String> {
    switch(this){
        case LazyValidation(x):
            return x(value, name).errors();
        case  ReadyValidation(x):
            return x.errors();
        case LazyErrors(x):
          return x(value, name);
        case LazyErrorsNameless(x):
            return x(value);
    }
  }

}

enum ValidationEnum<T> {
    LazyValidation(v:T->String->Validation<T>);
    ReadyValidation(v:Validation<T>);
    LazyErrors(v:T->String->ReadOnlyArray<String>);
    LazyErrorsNameless(v:T->ReadOnlyArray<String>);
}
