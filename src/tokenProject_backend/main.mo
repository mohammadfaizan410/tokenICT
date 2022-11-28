import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
actor Token{
    var owner : Principal = Principal.fromText("5jcqm-ynchw-s7ecs-7ko7j-2tf3t-o5htx-xsuz4-3fre2-gdis6-jvzg7-dqe");
    var totalSupply : Nat = 1000000000;
    var symbol : Text = "FIZZ";
    private stable var balances: [(Principal, Nat)] = [];
    private var tokenBalances = HashMap.HashMap<Principal,Nat>(1, Principal.equal, Principal.hash);

    public query func balanceOf(who:Principal) : async Nat{
        let balance : Nat = switch((tokenBalances.get(who))){
            case null 0;
            case (?result)  result;
        };      
       return balance;
    };

    public shared(msg) func payFree(): async Text{
      if(tokenBalances.get(msg.caller) == null){
      let amount : Nat = 1000;
      let ownerBalance = await balanceOf(owner);
      let newOwnerBalance : Nat= ownerBalance - amount;
      tokenBalances.put(owner,newOwnerBalance);
      tokenBalances.put(msg.caller, amount);
      return "success";
      }
      else{
        return "you have already claimed your tokens!"
      }
    };

    public shared(msg) func tranfer(to:Principal, amount:Nat): async Text{
        let senderBalance = await balanceOf(msg.caller);
        if(senderBalance > amount){
          
          let newSenderBalance : Nat = senderBalance - amount;
          tokenBalances.put(msg.caller,newSenderBalance);

          let recieverBlance = await balanceOf(to);
          let newRecieverBalance = recieverBlance + amount;
          tokenBalances.put(to,newRecieverBalance);

          return "Successfully Transfered!";
        }
        else{
          return "not enough balance!";
        }
    };

    system func preupgrade(){
        balances := Iter.toArray(tokenBalances.entries());
    };
    system func postupgrade(){
        tokenBalances := HashMap.fromIter<Principal,Nat>(balances.vals(), 1, Principal.equal, Principal.hash);
        if(tokenBalances.size() < 1){
              tokenBalances.put(owner,totalSupply);
        }
    };

}