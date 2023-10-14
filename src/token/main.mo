// 44hes-5bv3t-dwisd-5lm73-26gsw-xyjyh-h3s3s-mjr3y-5ff3y-a6rbx-wqe
import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
actor Token{
    Debug.print("Hello");


    let owner: Principal=Principal.fromText("44hes-5bv3t-dwisd-5lm73-26gsw-xyjyh-h3s3s-mjr3y-5ff3y-a6rbx-wqe");
    let totalSupply: Nat=1000000000;
    let symbol: Text="SHINX";

    private stable var balanceEntries: [(Principal, Nat)]=[];

    private var balances=HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);
     if (balances.size() < 1) {
        balances.put(owner, totalSupply);
    };

    public query func balanceOf(who:Principal):async Nat {
        let balance: Nat = switch (balances.get(who)){
            case null 0;
            case (?result) result;
        };

        return balance;

        // if(balances.get(who)==null){
        //     return 0;
        // }else{
        //     return balances.get(who);
        // }
    };

    public query func getSymbol(): async Text{
        return symbol;
    };

    public shared(msg) func payOut(): async Text {
        Debug.print(debug_show(msg.caller));
        if(balances.get(msg.caller)==null){
        let amount=10000;
        let result=await transfer(msg.caller, amount);
        balances.put(msg.caller,amount);
        return result;
        }else{
            return "Already Claimed"
        }
    };

    public shared(msg) func transfer(to:Principal,amount:Nat): async Text{
        let fromBalance= await balanceOf(msg.caller);
        if(fromBalance > amount){
            let newFromBalance: Nat=fromBalance-amount;
            balances.put(msg.caller, newFromBalance);

            let toBalance= await balanceOf(to);
            let newToBalance= toBalance + amount;
            balances.put(to, newToBalance);
           
            return "Success";
        }else{
            return "Insufficient Funds";
        }
    };

    system func preupgrade(){
        balanceEntries := Iter.toArray(balances.entries());
    };

    system func postupgrade() {
    balances := HashMap.fromIter<Principal, Nat>(balanceEntries.vals(), 1, Principal.equal, Principal.hash);
    if (balances.size() < 1) {
        balances.put(owner, totalSupply);
    }
   };

};
