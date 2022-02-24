pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  ExampleExternalContract public exampleExternalContract;

  modifier notCompleted() {
    require(exampleExternalContract.completed() == false, "External contract is complete");
    _;
  }

  constructor(address exampleExternalContractAddress) {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  //  ( make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )
  mapping ( address => uint256 ) public balances;
  uint256 public constant threshold = 1 ether;
  uint256 public deadline = block.timestamp + 90 seconds;
  bool openForWithdraw;

  event Stake(address staker, uint256 amount);
  event Withdrawn(address staker, uint256 amount);
  event Execute(uint256 timeSent);

  function stake(address staker) public payable {
    balances[staker] += msg.value;
    emit Stake(staker, msg.value);
  }


  // After some `deadline` allow anyone to call an `execute()` function
  //  It should either call `exampleExternalContract.complete{value: address(this).balance}()` to send all the value
  function execute() public notCompleted {
    require(block.timestamp > deadline, "Deadline not reached");
    exampleExternalContract.complete{ value: address(this).balance }();
    emit Execute(block.timestamp);
  }


  // if the `threshold` was not met, allow everyone to call a `withdraw()` function
  // Add a `withdraw(address payable)` function lets users withdraw their balance
  function withdraw(address payable staker) public notCompleted {
    require(balances[msg.sender] > 0, "You have not staked any eth");
    require(timeLeft() == 0, "There is still time left to stake!");
    require(address(this).balance < 1 ether, "The amount staked has met the threshold");
    staker.transfer(balances[msg.sender]);
    emit Withdrawn(staker, balances[msg.sender]);
  }


  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
  function timeLeft() public view returns (uint256) {
    uint256 secondsLeft;
    if(block.timestamp < deadline) {
      secondsLeft = deadline - block.timestamp;
    } else {
      secondsLeft = 0;
    }

    return secondsLeft;
  }


  // Add the `receive()` special function that receives eth and calls stake()
  receive() external payable {
    stake(msg.sender);
  }

}
