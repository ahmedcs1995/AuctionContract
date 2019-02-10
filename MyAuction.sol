pragma solidity >=0.4.22 < 0.6.0;

contract MyAuction{

    //static 
    address public owner;
    
    
    //timestamps
    uint public auctionEndTime;
    
    // Current state of the auction.
    address public highestBidder;
    uint public highestBid;
    
    
     // Allowed withdrawals of previous bids
    mapping(address => uint) pendingReturns;
    
    // Set to true at the end, disallows any change.
    // By default initialized to `false`.
    bool ended;
      
   
    bool cancel;
    
    constructor(uint _biddingTime,address _owner,uint initialAmount) public {
        owner = _owner;
        auctionEndTime = now + _biddingTime;
        highestBid = initialAmount;
    }
    
    
    
    function placeBid() public payable onlyNotOwner onlyBeforeEnd highestBidCheck{
        
        
         if (highestBid != 0) {
            // Sending back the money by simply using
            // highestBidder.send(highestBid) is a security risk
            // because it could execute an untrusted contract.
            // It is always safer to let the recipients
            // withdraw their money themselves.
            pendingReturns[highestBidder] += highestBid;
        }
        
        highestBidder = msg.sender;
        highestBid = msg.value;
    }
    
    //owner can't bid 
     modifier onlyNotOwner { require(msg.sender == owner,"Owner cannot bid the auction"); _; }
     
     // for cancel auction
     modifier onlyOwner  { require(msg.sender != owner); _; }
     
     
      // for cancel auction
     modifier onlyNotCanceled  { require(cancel); _; }
     
     
     //check period is over.
     modifier onlyBeforeEnd { require(now <= auctionEndTime,"Auction already ended."); _; }
     
     
     
      //check higher Bid.
     modifier highestBidCheck { require(msg.value > highestBid,"There already is a higher bid."); _; }
    
    
 
     
    
    // Withdraw a bid that was overbid.
      function withdraw() public returns (bool) {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            // It is important to set this to zero because the recipient
            // can call this function again as part of the receiving call
            // before `send` returns.
            pendingReturns[msg.sender] = 0;

            if (!msg.sender.send(amount)) {
                // No need to call throw here, just reset the amount owing
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    } 
    
     // End the auction and send the highest bid
    // to the beneficiary.
    function auctionEnd() public {
       // 1. Conditions
        require(now >= auctionEndTime, "Auction not yet ended.");
        require(!ended, "auctionEnd has already been called.");

        // 2. Effects
        ended = true;
      

        // 3. Interaction
        owner.transfer(highestBid);
    }
     
  function cancelAuction()
        onlyOwner
        onlyBeforeEnd
        onlyNotCanceled
        returns (bool success)
    {
        cancel = true;
        return true;
    }
     
     
     
     
     
     
     
     
     
     
}
