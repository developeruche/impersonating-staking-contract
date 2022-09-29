//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {IERC721} from "./interfaces/IERC721.sol";

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: lib/openzeppelin-contracts.git/contracts/utils/Context.sol


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)



/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: lib/openzeppelin-contracts.git/contracts/access/Ownable.sol


// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)




/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: lib/openzeppelin-contracts.git/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)



/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

// File: lib/openzeppelin-contracts.git/contracts/token/ERC20/extensions/IERC20Metadata.sol


// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)




/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}





contract Staking is Ownable, ReentrancyGuard {

    /**
     * =============================================
     * -------- CUSTOM ERROR -----------------------
     * =============================================
     */
    error TransferFailed();
    error NotStaker();
    error InsufficientAmount();
    error PendingRequest();
    error DontHaveBoredApe();

    address immutable hydro;
    address immutable KVS;
    uint256 constant MAX_RATE = 2314814800000; //0.0000023148148/min 2314814800000
    uint256 constant delta = 17658811475;
    uint256 currentRate;
    uint256 totalStaked;
    bool stakeActive;
    address constant bored_ape_address = 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D;

    struct Withdrawals {
        uint248 amount;
        bool pending;
        uint256 releaseAt;
    }
    struct User {
        uint184 amount;
        uint72 checkpoint;
        uint256 ratePerMin;
        Withdrawals requests;
    }

    event StakeInto(address indexed user, uint256 indexed amountStaked);
    event StakeRemoved(address indexed user, uint256 indexed amountRemoved);
    event KvsMint(address indexed user, uint256 kvsAmount);
    event RateUpdated(uint256 indexed newRate);
    event HydroRequest(address user, uint256 amount, uint256 releaseAt);
    event HydroClaimed(address user, uint256 amount);
    mapping(address => User) userStakeData;

    constructor(address _hydro, address _KVS) {
        KVS = _KVS;
        hydro = _hydro;
        currentRate = MAX_RATE;
    }

    modifier active() {
        require(stakeActive, "Not open to staking");
        _;
    }

    function toggleStake(bool val) public onlyOwner {
        stakeActive = val;
    }

    /// @notice this user is staking hydro token to recieve KVS tokens
    function stake(uint256 _amount) external active {
        if(IERC721(bored_ape_address).balanceOf(msg.sender) == 0) { 
            revert DontHaveBoredApe();
        }
        if (!(IERC20(hydro).transferFrom(msg.sender, address(this), _amount)))
            revert TransferFailed();
        User storage u = userStakeData[msg.sender];
        uint256 toUse = currentRate;
        // this runs if the user is staking for the first time 
        if (u.amount <= 0) {
            syncRate(false);
            u.ratePerMin = toUse;
        }
        //send out pending rewards if there are any
        if (u.amount > 0) {
            uint256 rewardDebt = checkCurrentRewards(msg.sender);
            if (rewardDebt > 0) {
                IERC20(KVS).transfer(msg.sender, rewardDebt);
                emit KvsMint(msg.sender, rewardDebt);
            }
        }
        u.amount += uint184(_amount);
        u.checkpoint = uint72(block.timestamp);
        totalStaked += _amount;
        emit StakeInto(msg.sender, _amount);
    }

    /// @dev this function would return the amount of token the user have recieved over time
    function checkCurrentRewards(address _user)
        public
        view
        returns (uint256 bonus)
    {
        User memory u = userStakeData[_user];
        assert(u.amount > 0);
        assert(block.timestamp >= u.checkpoint);
        uint256 minPassed = (block.timestamp - u.checkpoint) / 60; // this would return the passed minitue the user has staked token on the platform
        uint256 minGen = u.ratePerMin * minPassed; // this is the amount of token this user have accumulated over the minitues 
        bonus = (minGen * u.amount) / 1e18; // rounding this down back to ether units
    }

    /// @dev this function would be used to manage the rate at which the reward is been distrubuted 
    function syncRate(bool dir) internal {
        uint256 reductionPercentile = (10 * MAX_RATE) / 1000000;
        if (dir) {
            currentRate += reductionPercentile;
        } else {
            currentRate -= reductionPercentile;
        }
        emit RateUpdated(currentRate);
    }

    /// @notice this would return the rate 
    function checkCurrentRate() public view returns (uint) {
        return currentRate;
    }

    /// @notice calling this function, the user would be able to recieve staking reward 
    function withdrawProfit(uint256 _amount) external nonReentrant {
        User storage u = userStakeData[msg.sender];
        if (u.amount <= 0) revert NotStaker();
        uint256 rewardDebt = checkCurrentRewards(msg.sender);
        if (rewardDebt < _amount) revert InsufficientAmount();
        //only update timestamp
        u.checkpoint = uint72(block.timestamp);
        IERC20(KVS).transfer(msg.sender, rewardDebt);
        emit KvsMint(msg.sender, rewardDebt);
    }

    /// @notice call the function to exit/ pullout all staking rewards 
    function exit() external nonReentrant {
        User storage u = userStakeData[msg.sender];
        if (u.amount <= 0) revert NotStaker();
        uint toSend = u.amount;
        uint256 acc = checkCurrentRewards(msg.sender);
        u.checkpoint = uint72(block.timestamp);
        if (acc > 0) {
            require(IERC20(KVS).transfer(msg.sender, acc));
            emit KvsMint(msg.sender, acc);
        }
        u.amount = 0;
        placeReq(toSend);
        syncRate(true);
        totalStaked -= toSend;
        emit StakeRemoved(msg.sender, u.amount);
    }

    function viewUser(address _user) public view returns (User memory) {
        return userStakeData[_user];
    }

    function withdrawFunds(uint256 _amount) external nonReentrant {
        User storage u = userStakeData[msg.sender];
        if (u.amount <= 0) revert NotStaker();
        if (_amount > u.amount) revert InsufficientAmount();
        placeReq(_amount);
        emit StakeRemoved(msg.sender, _amount);
        //send out bonus too
        if (checkCurrentRewards(msg.sender) > 0) {
            require(
                IERC20(KVS).transfer(
                    msg.sender,
                    checkCurrentRewards(msg.sender)
                )
            );
            emit KvsMint(msg.sender, checkCurrentRewards(msg.sender));
        }
        u.amount -= uint184(_amount);
        totalStaked -= _amount;
        if (u.amount == 0) {
            syncRate(true);
        }
        //reset checkpoint
        u.checkpoint = uint72(block.timestamp);
    }

    function placeReq(uint256 amount) internal {
        User storage u = userStakeData[msg.sender];
        if (u.requests.pending) revert PendingRequest();
        u.requests.pending = true;
        u.requests.amount = uint248(amount);
        u.requests.releaseAt = block.timestamp + 7 days;
        emit HydroRequest(msg.sender, amount, block.timestamp + 7 days);
    }

    function claimHydro() public nonReentrant {
        User storage u = userStakeData[msg.sender];
        uint256 amount = u.requests.amount;
        require(block.timestamp >= u.requests.releaseAt, "Cannot release yet");
        //reset vals
        u.requests.amount = 0;
        u.requests.pending = false;
        require(IERC20(hydro).transfer(msg.sender, amount));

        emit HydroClaimed(msg.sender, amount);
    }

    function totalHydroStaked() public view returns (uint) {
        return totalStaked;
    }

    function transferOut(address token, uint256 amount) public onlyOwner {
        IERC20(token).transfer(msg.sender, amount);
    }

    function modifyRate(uint256 _newRate) public onlyOwner {
        currentRate = _newRate;
        emit RateUpdated(currentRate);
    }

    //current rate/10e5
    function checkAPY() public view returns (uint apy) {
        apy = (currentRate * 10e5) / delta;
    }
}