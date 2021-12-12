// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract WavePortal {

  uint256 private seed;

  // An event to listen for new waves
  event NewWave(address indexed from, uint256 timestamp, string message);

  // A struct to model a single wave
  struct Wave {
    address sender;
    uint256 timestamp;
    string message;
  }

  // Decalare a collection of waves
  Wave[] waves;

  // State Variables
  uint256 public totalWaves;
  address[] public allSenderAddresses;

  /*
   * This is an address => uint mapping, meaning I can associate an address with a number!
   * In this case, I'll be storing the address with the last time the user waved at us.
  */
  mapping(address => uint256) public lastWavedAt;

  constructor() payable{
    console.log("Yo, I am a smart contract!");
    seed = (block.difficulty + block.timestamp) % 100;
  }

  function waveAtMe(string memory _message) public {

    require(lastWavedAt[msg.sender] + 15 seconds  < block.timestamp, "Wait 15m");

    /*
     * Update the current timestamp we have for the user
     */
    lastWavedAt[msg.sender] = block.timestamp;

    totalWaves++;
    console.log("%s waved w/ message %s", msg.sender, _message);

    /*
    * This is where I actually store the wave data in the array.
    */
    waves.push(Wave(msg.sender, block.timestamp, _message));

    seed = (block.difficulty + block.timestamp + seed) % 100;

    if(seed <= 50){
        // To notify listeners like the frontend about a new wave that just came in 
        uint256 prizeAmount = 0.0001 ether;
        require(prizeAmount <= address(this).balance, "Trying to withdraw more money than the contract has.");

        (bool success,) = (msg.sender).call{value: prizeAmount}("");
        require(success, "Failed to withdraw money from contract.");
        console.log("Won some ethers");
     }

    emit NewWave(msg.sender, block.timestamp, _message);

    // Add sender's address to the addresser's list
    allSenderAddresses.push(msg.sender);
  }

   // Local variable
  function getAllWavesData() public view returns(Wave[] memory) {
    return waves;
  }

  // Local variable
  function getWavesCount() public view returns(uint256) {
    console.log("You have %d total waves", totalWaves);
    return totalWaves;
  }

  function getSendersList() public view returns(address[] memory){
    return allSenderAddresses;
  }

  
}

