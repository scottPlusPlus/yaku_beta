package yaku_beta.valid;

import tink.CoreApi.Outcome;
import tink.core.Error;

class Validator<T> {

    public var rules:Array<ValidationRule<T>> = [];

    public function new(){
    }

    public function errors(x:T):Array<String> {
        var errs = new Array<String>();
        for (rule in rules){
            var res = rule(x);
            switch (res){
                case Pass:
                case Fail(errors):
                    errs = errs.concat(errors);
                case FailAndExit(errors):
                    errs = errs.concat(errors);
                    break;
            }
        }
        return errs;
    }

    public function firstError(x:T):Null<String> {
        return errors(x).shift();
    }

    public function assertValid(x:T):Outcome<T,Error> {
        var err = firstError(x);
        if (err == null){
            return Success(x);
        }
        return Failure(new Error(ErrorCode.BadRequest, err));
    }

    public function asRule<X>(mapper:X->T):ValidationRule<X> {
        return function(x:X):ValidationOutcome {
            var t = mapper(x);
            var errs = errors(t);
            if (errs.length == 0){
                return Pass;
            }
            return Fail(errs);
        }
    }

    /*
    * returns this, for fluid api
    */
    public function addRule(rule:ValidationRule<T>):Validator<T>{
        rules.push(rule);
        return this;
    }
}