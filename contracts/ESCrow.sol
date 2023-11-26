// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// Import necessary libraries
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract BlockCrow is Ownable {
    // Project structure
    struct Project {
        string projectDID;
        address freelancer;
        uint256 totalAmount;
        uint256 completionTimestamp;
        bool completed;
        mapping(uint256 => uint256) milestones; // milestoneId => amount
    }

    IERC20 public immutable paymentToken; // ERC20 token used for payments
    Project public immutable project; // Project details

    // Events
    event ProjectCreated(bytes32 indexed projectDID, address indexed client, address indexed freelancer);
    event FundsDeposited(bytes32 indexed projectDID, uint256 amount);
    event FundsReleased(bytes32 indexed projectDID, uint256 amount);
    event ProjectCompleted(bytes32 indexed projectDID);

    // Constructor
    constructor(
        address _paymentToken,
        bytes32 projectDID,
        address freelancer,
        uint256 totalAmount,
        uint256 completionTimestamp
    ) {
        project = Project({
            projectDID: projectDID,
            freelancer: freelancer,
            totalAmount: totalAmount,
            completionTimestamp: completionTimestamp,
            completed: false,
        });

        emit ProjectCreated(projectDID, msg.sender, freelancer);
    }

    // Deposit funds into escrow
    function depositFunds(bytes32 projectDID, uint256 amount) external onlyOwner {
        require(!project.completed, "Project completed");
        paymentToken.transferFrom(msg.sender, address(this), amount);
        emit FundsDeposited(projectDID, amount);
    }

    // Release funds from escrow
    function releaseFunds(bytes32 projectDID, uint256 milestoneId) external {
        require(msg.sender == project.freelancer, "Not authorized");
        require(!project.completed, "Project completed");
        require(block.timestamp >= project.completionTimestamp, "Project not yet completed");
        require(project.milestones[milestoneId] > 0, "Invalid milestone");

        uint256 amount = project.milestones[milestoneId];
        project.milestones[milestoneId] = 0;
        paymentToken.transfer(project.freelancer, amount);

        emit FundsReleased(projectDID, amount);

        // Check if all milestones are completed to mark the project as completed
        if (allMilestonesCompleted(projectDID)) {
            project.completed = true;
            emit ProjectCompleted(projectDID);
        }
    }

    // Check if all milestones are completed
    function allMilestonesCompleted(bytes32 projectDID) internal view returns (bool) {
        for (uint256 i = 1; i <= project.milestones.length; i++) {
            if (project.milestones[i] > 0) {
                return false;
            }
        }
        return true;
    }
}
