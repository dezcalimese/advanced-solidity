// SPDX-License-Identifier: MIT

pragma solidity 0.8.16;

contract IsPrime {
    function isPrime(uint256 x) public pure returns (bool p) {
        p = true;
        assembly {
            let halfX := add(div(x, 2), 1)
            for {
                let i := 2
            } lt(i, halfX) {

            } {
                if iszero(mod(x, i)) {
                    p := 0
                    break
                }

                i := add(i, 1)
            }
        }
    }

    function testPrime() external pure {
        require(isPrime(2));
        require(isPrime(3));
        require(!isPrime(4));
        require(!isPrime(15));
        require(isPrime(23));
        require(isPrime(101));
    }
}

contract IfComparison {
    function isTruthy() external pure returns (uint256 result) {
        result = 2;
        assembly {
            if 2 {
                result := 1
            }
        }

        return result; // returns 1
    }

    function isFalsy() external pure returns (uint256 result) {
        result = 1;
        assembly {
            if 0 {
                result := 2
            }
        }

        return result; // returns 1
    }

    // iszero(0) will result in 32 bytes being all zero execpt a 1 at the end, evaluating as true
    function negation() external pure returns (uint256 result) {
        result = 1;
        assembly {
            if iszero(0) {
                result := 2
            }
        }

        return result; // returns 2
    }

    function unsafe1NegationPart1() external pure returns (uint256 result) {
        result = 1;
        assembly {
            if not(0) {
                result := 2
            }
        }

        return result; // returns 2
    }

    function bitFlip() external pure returns (bytes32 result) {
        assembly {
            result := not(2)
        }
    }

    function unsafe2NegationPart() external pure returns (uint256 result) {
        result = 1;
        assembly {
            if not(2) {
                result := 2
            }
        }

        return result; // returns 2
    }

    function safeNegation() external pure returns (uint256 result) {
        result = 1;
        assembly {
            if iszero(2) {
                result := 2
            }
        }

        return result; // returns 1
    }

    function max(uint256 x, uint256 y) external pure returns (uint256 maximum) {
        assembly {
            if lt(x, y) {
                maximum := y
            }
            if iszero(lt(x, y)) {
                // there are no else statements
                maximum := x
            }
        }
    }

    // The rest:
    // These are all operations on 32 bit words
    // Need to watch out for over/under flow in Yul
    /*
        | solidity | YUL       |
        +----------+-----------+
        | a && b   | and(a, b) |
        +----------+-----------+
        | a || b   | or(a, b)  |
        +----------+-----------+
        | a ^ b    | xor(a, b) |
        +----------+-----------+
        | a + b    | add(a, b) |
        +----------+-----------+
        | a - b    | sub(a, b) |
        +----------+-----------+
        | a * b    | mul(a, b) |
        +----------+-----------+
        | a / b    | div(a, b) |
        +----------+-----------+
        | a % b    | mod(a, b) |
        +----------+-----------+
        | a >> b   | shr(b, a) |
        +----------+-----------+
        | a << b   | shl(b, a) |
        +----------------------+
    */
}
