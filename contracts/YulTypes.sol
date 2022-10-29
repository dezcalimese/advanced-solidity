// SPDX-License-Identifier: MIT

pragma solidity 0.8.16;

contract YulTypes {
    function getNumber() external pure returns (uint256) {
        // return 42;
        uint256 x;

        assembly {
            x := 42
        }

        return x;
    }

    function getHex() external pure returns (uint256) {
        /* 
        This will return 10
        0xa returns decimal 10, but Solidity interprets it 
        as a decimal when its in a uint256.
        */
        uint256 x;

        assembly {
            x := 0xa // 0xa = decimal 10
        }

        return x;
    }

    function demoString() external pure returns (string memory) {
        /* 
        // This will compile, but nothing will be returned. 
        // The transaction actually runs out of gas when running this function.

        // Here, the string is not being stored in the stack.
        string memory myString = "";

        // This is trying to assign "hello world" into the pointer.
        // There's a pointer in the stack to a location in memory.
        assembly {
            myString := "hello world"
        }

        return myString;
        */

        // Proper way to do this
        bytes32 myString = "";

        assembly {
            myString := "hello world"
        }

        /*
        // This returns the bytes32 representation of "hello world".
        return myString;
        */

        // This will return in human readable form.
        // This assumes the string you put in is less than 32 bytes.
        return string(abi.encode(myString));
    }

    function representation() external pure returns (bool) {
        bool x;

        assembly {
            x := 1
        }

        return x;
    }
}
