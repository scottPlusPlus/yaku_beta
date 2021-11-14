package yaku_beta.valid;

using yaku_core.NullX;

@:forward(allowNull, itemName, rules, tinkErrAdapter, errors, firstError, isValid, validOutcome, asRule, addRule)
@:access(yaku_beta.valid.Validator)
abstract ArrayValidator<T> (Validator<Array<T>>) from Validator<Array<T>> to Validator<Array<T>> {

    public function new(itemName:String){
        this = new Validator<Array<T>>(itemName);
    }

    public function minLength(v:UInt, ?errMsgOverride:String):ArrayValidator<T> {
        var f = function(x:Array<T>):ValidationOutcome {
            if (x.length < v){
                var errMsg = errMsgOverride.orFallback('${this.itemName} must have at least ${v} items.');
                return Fail([errMsg]);
            }
            return Pass;
        }
        this.rules.push(f);
        return this;
    }

    public function maxLength(v:UInt, ?errMsgOverride:String):ArrayValidator<T> {
        var f = function(x:Array<T>):ValidationOutcome {
            if (x.length > v){
                var errMsg = errMsgOverride.orFallback('${this.itemName} must can have at most ${v} items.');
                return Fail([errMsg]);
            }
            return Pass;
        }
        this.rules.push(f);
        return this;
    }

    public function validateEach(validator:Validator<T>):ArrayValidator<T> {
        var f = function(x:Array<T>):ValidationOutcome {
            var errs = [];
            for (item in x){
                var itemErrs = validator.errors(item);
                errs = errs.concat(itemErrs);
            }
            if (errs.length > 0){
                return Fail(errs);
            }
            return Pass;
        }
        this.rules.push(f);
        return this;
    }
}