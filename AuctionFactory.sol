pragma solidity >=0.4.22 <0.6.0;

import { MyAuction } from './MyAuction.sol';
contract AuctionFactory {
    MyAuction[] public auctions;
    
    constructor() public{
        
    }
     function createAuction(){
         MyAuction newAuction = new MyAuction(120,msg.sender,0.01 ether);
         auctions.push(newAuction);
     }
     
    function getAuctions() public view returns (MyAuction []){
         return auctions;
     }
}
