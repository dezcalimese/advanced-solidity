// SPDX-License-Identifier: GPL-3
pragma solidity 0.8.16;

contract StorageBasics {
    uint256 x = 2;
    uint256 y = 13;
    uint256 z = 24;
    uint128 a = 1;
    uint128 b = 1;

    function getSlot() external pure returns (uint256 slot) {
        assembly {
            slot := b.slot
        }
    }

    function getXYul() external view returns (uint256 ret) {
        assembly {
            ret := sload(x.slot)
        }
    }

    function getVarYul(uint256 slot) external view returns (uint256 ret) {
        assembly {
            ret := sload(slot)
        }
    }

    function setVarYul(uint256 newVal) external {
        assembly {
            sstore(y.slot, newVal)
        }
    }

    function setX(uint256 newVal) external {
        x = newVal;
    }

    function getX() external view returns (uint) {
        return x;
    }
}
