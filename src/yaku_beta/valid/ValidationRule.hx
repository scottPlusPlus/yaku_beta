package yaku_beta.valid;

abstract ValidationRule<T> (ValidationEnum<T>) from ValidationEnum<T> {

  @:from inline static function fromLazyValidation<T>(x:T->String->Validation<T>):ValidationRule<T> {
    return ValidationEnum.LazyValidation(x);
  }

  @:from inline static function fromLazyValidationNamless<T>(x:T->Validation<T>):ValidationRule<T> {
    return ValidationEnum.LazyValidationNameless(x);
  }

  @:from inline static function fromReadyValidation<T>(x:Validation<T>):ValidationRule<T> {
    return ValidationEnum.ReadyValidation(x);
  }

  @:from inline static function fromLazyErrors<T>(x:T->String->Iterable<String>):ValidationRule<T> {
    return ValidationEnum.LazyErrors(x);
  }

  @:from inline static function fromLazyErrorsNameless<T>(x:T->Iterable<String>):ValidationRule<T> {
    return ValidationEnum.LazyErrorsNameless(x);
  }

  public function errors(value:T, name:String) :Iterable<String> {
    switch(this){
        case LazyValidation(x):
            return x(value, name).errors();
        case LazyValidationNameless(x):
            return x(value).errors();
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
    LazyValidationNameless(v:T->Validation<T>);
    ReadyValidation(v:Validation<T>);
    LazyErrors(v:T->String->Iterable<String>);
    LazyErrorsNameless(v:T->Iterable<String>);
}
