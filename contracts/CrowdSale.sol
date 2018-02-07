pragma solidity ^0.4.18;

import "./MiniMeToken.sol";
import "./SafeMath.sol";
import "./Pausable.sol";

contract CrowdSale is Pausable {
    using SafeMath for uint256;
    
    uint256 public startFundingTime = 1517990460; // Feb 7, 2018 @ 08h01 UTC == 00h01 PDT        
    uint256 public endFundingTime = 1523779200;   // Apr 15, 2018 @ 08h00 UTC == 08h00 PDT
        
    uint256 public totalEtherCollected;           // In wei
    uint256 public totalTokensSold;               // KISSES tokens sold
    
    uint256 public etherToUSDrate = 800;          // Default exchange rate 
    
    MiniMeToken public tokenContract;             // The  token for this CrowdSale
    
    address public etherVault = 0x674552169ec1683Aa26aa7406337FAc67BF31ED5; // The address holding the Ether received
    address public unsoldTokensVault = 0x5316e0A703a584ECa2e95B73B4E6dB8E98E089e0; // The address where all unsold tokens will be sent to
 
    address public tokenVault;                    // The address holding the KISSES tokens for sale
    
    // Logs purchaser address and investment amount - to be used to track top 100 investors
    event Purchase(address investor, uint256 weiReceived, uint256 tokensSold);
    
    // Constructor - takes address of token contract as parameter
    // Assumes msg.sender is address of the tokenVault <==> msg.sender also deployed tokenContract
    function CrowdSale(address _tokenAddress) public {
        require (_tokenAddress != address(0));            
        
        tokenContract = MiniMeToken(_tokenAddress);     

        tokenVault = msg.sender;
    }
    
    // Fallback function invokes internal doPayment method
    function () public whenNotPaused payable {
        doPayment(msg.sender);
    }
    
    // Internal logic that processes payments
    function doPayment(address _owner) internal {

        // First check that the Campaign is allowed to receive this donation
        require ((now >= startFundingTime) && (now <= endFundingTime) && (msg.value != 0));
        
        // Calculate the number of tokens purchased and the dollar amount thereof
        uint256 tokens = calculateTokens(msg.value);
           
        // Track how much Ether the campaign has collected
        totalEtherCollected = totalEtherCollected.add(msg.value);
        // Track how many KISSES tokens the campaign has sold
        totalTokensSold = totalTokensSold.add(tokens);        

        // Send the ether to the etherVault
        require (etherVault.send(msg.value));

        // Transfer tokens from tokenVault to the _owner address
        // Will throw if tokens exceeds balance in remaining in tokenVault
        require (tokenContract.transferFrom(tokenVault, _owner, tokens));
        
        // Emit the Purchase event 
        Purchase(_owner, msg.value, tokens);
        
        return;
    }
    
    // Handles the bonus logic & conversion from Ether's 18 decimal places to 5 decimals for the KISSES token
    function calculateTokens(uint256 _wei) internal view returns (uint256) {
 
        uint256 weiAmount = _wei;
        uint256 USDamount = (weiAmount.mul(etherToUSDrate)).div(10**14); // preserves 4 decimal places

        uint256 purchaseAmount; 
        uint256 withBonus;
 
        // if purchase made between 07 & 14 February 2018
        if(now < 1518595200) {
            purchaseAmount = USDamount; // 1 Token == 1 USD
            // minimum purchase of one token, maximum of three hundred and fifty thousand
            if(purchaseAmount < 10000 || purchaseAmount > 3500000000) {
                 revert();
            }
            else {
                 withBonus = purchaseAmount.mul(19); // 90% bonus for the whole week
                 return withBonus;
            }   
        }
 
        // if purchase made between 14 & 15 February 2018
        else if(now >= 1518595200 && now < 1518681600) {
            purchaseAmount = USDamount; // 1 Token == 1 USD
            // minimum purchase of one token, maximum of three hundred and fifty thousand
            if(purchaseAmount < 10000 || purchaseAmount > 3500000000) {
                 revert();
            }
            else {
                 withBonus = purchaseAmount.mul(18); // 80% bonus for the whole of Valentine's Day
                 return withBonus;
            }   
        }

        // if purchase made between 15 February and 21 February
        else if(now >= 1518681600 && now < 1519286400) {
            purchaseAmount = USDamount; // 1 Token == 1 USD
            // minimum purchase of one token, maximum of three hundred and fifty thousand
            if(purchaseAmount < 10000 || purchaseAmount > 3500000000) {
                revert();
            }     
            else {
                if(weiAmount >= 500 finney && weiAmount < 1 ether) {
                    withBonus = purchaseAmount.mul(11); // 10% bonus
                    return withBonus;
                }
                else if(weiAmount >= 1 ether) {
                    withBonus = purchaseAmount.mul(16); // 60% bonus
                    return withBonus;                
                }
                else {
                    withBonus = purchaseAmount.mul(10); // no bonus
                    return withBonus;
                }
            }
        }

        // if purchase made between 22 February and 28 February
        else if(now >= 1519286400 && now < 1519891200) {
            purchaseAmount = USDamount; // 1 Token == 1 USD
            // minimum purchase of one token, maximum of three hundred and fifty thousand
            if(purchaseAmount < 10000 || purchaseAmount > 3500000000) {
                revert();
            }
            else {
                if(weiAmount >= 500 finney && weiAmount < 1 ether) {
                    withBonus = purchaseAmount.mul(11); // 10% bonus
                    return withBonus;
                }
                else if(weiAmount >= 1 ether) {
                    withBonus = purchaseAmount.mul(15); // 50% bonus
                    return withBonus;                
                }
                else {
                    withBonus = purchaseAmount.mul(10); // no bonus
                    return withBonus;
                }
            }
        }

        // if purchase made between 1 March and 14 March
        else if(now >= 1519891200 && now < 1521100800) {
            purchaseAmount = (USDamount.mul(10)).div(14); // 1 KISSES = 1.4 USD
            if(purchaseAmount < 10000 || purchaseAmount > 3500000000) {
                revert();
            }
            else {
                if(weiAmount >= 500 finney && weiAmount < 1 ether) {
                    withBonus = purchaseAmount.mul(11); // 10% bonus
                    return withBonus;
                }
                else if(weiAmount >= 1 ether && weiAmount < 5 ether) {
                    withBonus = purchaseAmount.mul(13); // 30% bonus
                    return withBonus;
                }
                else if(weiAmount >= 5 ether && weiAmount < 8 ether) {
                    withBonus = purchaseAmount.mul(14); // 40% bonus
                    return withBonus;
                }              
                else if(weiAmount >= 8 ether) {
                    withBonus = purchaseAmount.mul(15); // 50% bonus
                    return withBonus;
                }
                else {
                    withBonus = purchaseAmount.mul(10); // no bonus
                    return withBonus;
                }              
            }
        }  

        // if purchase made between 15 March and 31 March
        else if(now >= 1521100800 && now < 1522569600) {
            purchaseAmount = (USDamount.mul(10)).div(19); // 1 KISSES = 1.9 USD
            // minimum purchase of one token, maximum of three hundred and fifty thousand
            if(purchaseAmount < 10000 || purchaseAmount > 3500000000) {
                revert();
            }
            else {
                if(weiAmount >= 500 finney && weiAmount < 1 ether) {
                    withBonus = purchaseAmount.mul(11); // 10% bonus
                    return withBonus;
                } 
                else if(weiAmount >= 1 ether && weiAmount < 5 ether) {
                    withBonus = purchaseAmount.mul(13); // 30% bonus
                    return withBonus;
                }
                else if(weiAmount >= 5 ether && weiAmount < 8 ether) {
                    withBonus = purchaseAmount.mul(14); // 40% bonus
                    return withBonus;               
                }              
                else if(weiAmount >= 8 ether) {
                    withBonus = purchaseAmount.mul(15); // 50% bonus
                    return withBonus;               
                }              
                else {
                    withBonus = purchaseAmount.mul(10); // no bonus
                    return withBonus;               
                }
            }
        }

        // if purchase made between 1 April and 14 April
        else if(now > 1522569600 && now <= endFundingTime) {
            purchaseAmount = (USDamount.mul(10)).div(27); // 1 KISSES = 2.7 USD
            // minimum purchase of one token, maximum of three hundred and fifty thousand
            if(purchaseAmount < 10000 || purchaseAmount > 3500000000) {
                revert();
            }
            else{
                if(weiAmount >= 500 finney && weiAmount < 1 ether) {
                    withBonus = purchaseAmount.mul(11); // 10% bonus
                    return withBonus;
                }
                else if(weiAmount >= 1 ether && weiAmount < 5 ether) {
                    withBonus = purchaseAmount.mul(13); // 30% bonus
                    return withBonus;               
                }
                else if(weiAmount >= 5 ether && weiAmount < 8 ether) {
                    withBonus = purchaseAmount.mul(14); // 40% bonus
                    return withBonus;               
                }              
                else if(weiAmount >= 8 ether) {
                    withBonus = purchaseAmount.mul(15); // 50% bonus
                    return withBonus;              
                }              
                else {
                    withBonus = purchaseAmount.mul(10); // no bonus
                    return withBonus;               
                }
            }
        }
    }
    
    // Method to change the etherVault address
    function setVault(address _newVaultAddress) public onlyController whenPaused {
        etherVault = _newVaultAddress;
    }
    
    // Method to change the Ether to Dollar exchange rate 
    function setEthToUSDRate(uint256 _rate) public onlyController whenPaused {
        etherToUSDrate = _rate;
    }    
        
    // Wrap up CrowdSale and direct any ether stored in this contract to etherVault
    function finalizeFunding() public onlyController {
        require(now >= endFundingTime);
        uint256 unsoldTokens = tokenContract.allowance(tokenVault, address(this));
        if(unsoldTokens > 0) {
            require (tokenContract.transferFrom(tokenVault, unsoldTokensVault, unsoldTokens));
        }
        selfdestruct(etherVault);
    }
    
}