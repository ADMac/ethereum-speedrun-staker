pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  ExampleExternalContract public exampleExternalContract;

  constructor(address exampleExternalContractAddress) public {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  //  ( make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )
  mapping ( address => uint256 ) public balances;
  uint256 public constant threshold = 1 ether;

  event Stake(address staker, uint256 amount);

  function stake(address staker) payable {
    balances[staker] += msg.value;
    emit Stake(staker, msg.value);
  }


  // After some `deadline` allow anyone to call an `execute()` function
  //  It should either call `exampleExternalContract.complete{value: address(this).balance}()` to send all the value
  function execute() {
    require()
    exampleExternalContract.complete{value: address(this).balance}();
  }


  // if the `threshold` was not met, allow everyone to call a `withdraw()` function


  // Add a `withdraw(address payable)` function lets users withdraw their balance
  function withdraw(address payable staker) {
    require(balances[msg.sender] > 0);
    require();
    // withdraw assets
  }


  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
  function timeLeft() public view return(uint) {
    return 5;
  }


  // Add the `receive()` special function that receives eth and calls stake()
  function receive() public payable {
    stake(msg.sender, msg.value);
  }

}
