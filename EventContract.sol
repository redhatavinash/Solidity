// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

contract Event{
    address public EventManager;
    address payable[] EventAttendees;
    mapping(address=> uint256) balances;
    uint256 TotalEntries;
    uint256 SingleEntries;
    uint256 TeamEntries;
    address[] AllAddresses; 
    address[] SingleAddresses;
    address[] TeamAddresses;


    constructor(){
        EventManager=msg.sender;
    }

    receive() external payable { 
       for(uint i=0;i<TotalEntries;i++){
        EventAttendees.push(payable(AllAddresses[i]));
       }
    }

    function TransferToAdmin() public payable{
        require(msg.sender!=EventManager,"event manager cannot send funds to themselves");
        if(msg.value==1 ether){
            balances[msg.sender]+=msg.value;
            TotalEntries++;
            SingleEntries++;
            SingleAddresses.push(msg.sender);
            if(balances[msg.sender]>0){
                AllAddresses.push(msg.sender);
            }
        }
        else if(msg.value%2==0){
            balances[msg.sender]+=msg.value;
            TotalEntries++;
            TeamEntries++;
            TeamAddresses.push(msg.sender);
            if(balances[msg.sender]>0){
                AllAddresses.push(msg.sender);
            }
        }
        else{
            revert("Please transfer in multiple of 2 ethers if you are a team, so we can know the number of participants.");
        }
    }

    function SeeUserBalance(address user) public view returns(uint256){
        require(msg.sender==EventManager);
        return balances[user];
    }

    function GetBalance() public view returns(uint){
        require(msg.sender==EventManager);
        return address(this).balance;
    }

    function GetAllAddresses() public view returns (address[] memory) {
        require(msg.sender==EventManager);
        return AllAddresses;
    }

    function NumberOfEntries() public view returns(uint){
        require(msg.sender==EventManager);
        return TotalEntries;
    }

    function TotalSingleEntries() public view returns(uint256){
        return SingleEntries;
    }

    function TotalTeamEntries() public view returns(uint256){
        return TeamEntries;
    }

    function SingleWallets() public view returns(address[] memory){
        require(msg.sender==EventManager);
        return SingleAddresses;
    }

     function TeamWallets() public view returns(address[] memory){
        require(msg.sender==EventManager);
        return TeamAddresses;
    }

}
