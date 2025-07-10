// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

enum SponsorLevels {
    Basic,
    Bronze,
    Silver,
    Gold,
    Platinum
}

/// @title Subscription tracking machine
/// @author Maksim Eastwood
/// @notice Use this contract for working with subscriptions
/// @dev Contract under development to increase the functionality
contract SponsorLevelsMachine {
    address immutable public owner;

    struct Subscription {
        SponsorLevels level;
        uint amount;
        uint timeOfTransaction;
    }

    mapping (address => Subscription) subscribers;

    uint8 public freeBronze;
    uint8 public freeSilver;
    uint8 public freeGold;
    uint8 public freePlatinum;

    /// @notice Constructor contains initial initialization for state variables
    /// @dev If you want to change count of subscriptions on different levels, you should change the formula
    constructor() {
        owner = msg.sender;

        uint timestamp = block.timestamp;
        freeBronze = uint8(timestamp / 200000000);
        freeSilver = uint8(timestamp / 400000000);
        freeGold = uint8(timestamp / 600000000);
        freePlatinum = uint8(timestamp / 800000000);
    }

    /// @notice Allow users to buy a subscription
    /// @dev Function under development
    function buySubcription() external payable {
        SponsorLevels level = specifyLevel();

        Subscription memory subscription = Subscription (
            level,
            msg.value,
            block.timestamp
        );

        decVacantPlaces(level);

        subscribers[msg.sender] = subscription;
    }

    /// @notice Allow owner to withdraw all money
    /// @dev Function under development
    function withdrawAll() public {
        address payable to = payable(owner);
        address thisContract = address(this);

        to.transfer(thisContract.balance);
    }

    /// @notice Allow subscribers to check subscription info
    /// @dev Function under development
    function getInfoAboutMySubscription() external view returns(Subscription memory) {
        return subscribers[msg.sender];
    }

    /// @notice Allow users to check contract balancet
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /// @notice Vacant places counter
    /// @param _level Subscription level
    function decVacantPlaces(SponsorLevels _level) internal {
        if (_level == SponsorLevels.Bronze) {
            freeBronze--;
        } else if (_level == SponsorLevels.Silver) {
            freeSilver--;
        } else if (_level == SponsorLevels.Gold) {
            freeGold--;
        } else if (_level == SponsorLevels.Platinum){
            freePlatinum--;
        }
    }

    /// @notice Level handler
    /// @return level The subscription level
    function specifyLevel() internal view returns(SponsorLevels level) {
        if (msg.value == 2 ether) {
            level = SponsorLevels.Bronze;
        } else if (msg.value == 4 ether) {
            level = SponsorLevels.Silver;
        } else if (msg.value == 6 ether) {
            level = SponsorLevels.Gold;
        } else if (msg.value == 8 ether) {
            level = SponsorLevels.Platinum;
        } else {
            level = SponsorLevels.Basic;
        }
    }
}
