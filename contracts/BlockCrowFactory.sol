// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./BlockCrow.sol";

contract BlockCrowFactory is Ownable {
  constructor() Ownable(msg.sender) {}

  function createEscrow(
        address _paymentToken,
        string memory projectDID,
        address freelancer,
        uint256[] memory projectMilestones
  ) external payable returns (address) {
    BlockCrow escrow = new BlockCrow(msg.sender, _paymentToken, projectDID, freelancer, projectMilestones);
    escrow.depositFunds(msg.value);
    return address(escrow);
  }
}
