pragma solidity 0.8.4;

contract ExampleExternalContract {

  bool public completed;

  event Completed();

  function complete() public payable {
    completed = true;
    emit Completed();
  }

}
