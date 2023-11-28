// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// Import necessary libraries
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract BlockCrow is Ownable {
    // Project structure
    struct Project {
        string did;
        address freelancer;
        bool completed;
    }

    IERC20 public paymentToken; // ERC20 token used for payments
    Project public project; // Project details
    
    uint256[] public milestones; // milestones

    // constant address for platform wallet
    address public constant platformWallet = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    // Events
    event ProjectCreated(string indexed projectDID, address indexed client, address indexed freelancer);
    event FundsDeposited(string indexed projectDID, uint256 amount);
    event FundsReleased(string indexed projectDID, uint256 amount);
    event ProjectCompleted(string indexed projectDID);

    // Constructor
    constructor(
        address _owner,
        address _paymentToken,
        string memory projectDID,
        address freelancer,
        uint256[] memory projectMilestones
    ) Ownable(_owner) {
        project = Project({
            did: projectDID,
            freelancer: freelancer,
            completed: false
        });

        // copy milestones to storage
        for (uint256 i = 0; i < projectMilestones.length; i++) {
            milestones.push(projectMilestones[i]);
        }

        paymentToken = IERC20(_paymentToken);

        emit ProjectCreated(project.did, msg.sender, freelancer);
    }

    function balance() external view returns (uint256) {
        return paymentToken.balanceOf(address(this));
    }

    function totalMilestones() external view returns (uint256) {
        return milestones.length;
    }

    function completed() external view returns (bool) {
        return project.completed;
    }

    function completionProgress() external view returns (uint256) {
        for (uint256 i = 0; i <= milestones.length; i++) {
            if (milestones[i] > 0) {
                return i;
            }
        }
        return 0;
    }

    function balanceOf() external view returns (uint256) {
        return paymentToken.balanceOf(address(this));
    }

    // Deposit funds into escrow
    function depositFunds(uint256 amount) external onlyOwner {
        require(!project.completed, "Project completed");
        require(amount > totalMilestoneAmount(), "Not sufficient amount sent in");
        paymentToken.transferFrom(msg.sender, address(this), amount);
        emit FundsDeposited(project.did, amount);
    }

    // Release funds from escrow
    function releaseFunds(uint256 milestoneId, address wallet) external {
        require(msg.sender == project.freelancer, "Not authorized");
        require(!project.completed, "Project completed");
        require(milestones[milestoneId] > 0, "Invalid milestone");

        uint256 amount = milestones[milestoneId];
        milestones[milestoneId] = 0;
        // transfer 5% to the platform
        uint256 platformFee = amount / 20;
        paymentToken.transfer(wallet, amount - platformFee);

        emit FundsReleased(project.did, amount);

        // Check if all milestones are completed to mark the project as completed
        if (allMilestonesCompleted()) {
            project.completed = true;

            // transfer balance to platform
            paymentToken.transfer(platformWallet, paymentToken.balanceOf(address(this)));

            emit ProjectCompleted(project.did);
        }
    }

    // Check if all milestones are completed
    function allMilestonesCompleted() internal view returns (bool) {
        for (uint256 i = 0; i <= milestones.length; i++) {
            if (milestones[i] > 0) {
                return false;
            }
        }
        return true;
    }

    function totalMilestoneAmount() internal view returns (uint256 amount) {
        for (uint256 i = 0; i <= milestones.length; i++) {
            if (milestones[i] > 0) {
                amount = amount + milestones[i];
            }
        }
    }
}
