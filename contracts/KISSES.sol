pragma solidity ^0.4.18;

import "./MiniMeToken.sol";

/**
 * @title KISSES Token
 * @dev the KISSES Token implementation
 *      generates tokens per allocation and transfers control of token to 0x0
 *
 * requires control of tokenVault address - to invoke approve() spending by CrowdSale contract for 72mil tokens
 */
contract KISSES is MiniMeToken {
   
    uint8 public decimalPlaces = 5;
    
    // TOTAL_SUPPLY = 240 million tokens
    
    uint256 public crowdsaleVolume = 72000000 * 10 ** uint256(decimalPlaces);     // 30% == 72.00mil
    
    uint256 public ecosystemOneSupply = 48000000 * 10 ** uint256(decimalPlaces);  // 20% == 48.00mil
    uint256 public ecosystemTwoSupply = 24000000 * 10 ** uint256(decimalPlaces);  // 10% == 24.00mil 

    uint256 public legalOneSupply = 4800000 * 10 ** uint256(decimalPlaces);       //  2% ==  4.80mil
    uint256 public legalTwoSupply = 19200000 * 10 ** uint256(decimalPlaces);      //  8% == 19.20mil

    uint256 public bountyOneSupply = 4800000 * 10 ** uint256(decimalPlaces);      //  2% ==  4.80mil
    uint256 public bountyTwoSupply = 7200000 * 10 ** uint256(decimalPlaces);      //  3% ==  7.20mil
    
    uint256 public reserveSupply = 4800000 * 10 ** uint256(decimalPlaces);        //  2% ==  4.80mil
    
    uint256 public partnerOneSupply = 12000000 * 10 ** uint256(decimalPlaces);    //  5% == 12.00mil
    uint256 public partnerTwoSupply = 12000000 * 10 ** uint256(decimalPlaces);    //  5% == 12.00mil
    
    uint256 public teamOneSupply = 12000000 * 10 ** uint256(decimalPlaces);       //  5% == 12.00mil
    uint256 public teamTwoSupply = 12000000 * 10 ** uint256(decimalPlaces);       //  5% == 12.00mil
      
    uint256 public tokenSaleFund = 7200000 * 10 ** uint256(decimalPlaces);        //  3% ==  7.20mil    

    address public crowdsaleVault = msg.sender;
    
    address public ecosystemOneVault = 0xAaf97BE1Db2F93DB5e1244bc3932956852a6A213;
    address public ecosystemTwoVault = 0x47e7411db7419c1b93710d8E0e2423e9e6A8E575; 

    address public legalOneVault = 0xb0D1305F85E2346626a464a0ACd7eA1d2e3cF4Fc;
    address public legalTwoVault = 0x4B3319d902a149C631dA2ba285898bBa9B7bd1e2;

    address public bountyOneVault = 0xa6c7FB9B1807755DA499aD38F7B15CdF71a0bd4b;
    address public bountyTwoVault = 0x77639C705F5Cab25cb2aEAbb156A64747828CC1f;
    
    address public reserveVault = 0x5923084d799440D52899127Fc4d82A665d029aFA;
    
    address public partnerOneVault = 0x6667f868D869B3373Dc5A0A7F9c62FC0e7383F86;
    address public partnerTwoVault = 0x446abF119D8e9A0a5eAcC41c1611385983Bc4afD;
    
    address public teamOneVault = 0x427757ca7117128E94C76311CADD10745D90A197;
    address public teamTwoVault = 0x70EDc040aE36fccc509Bc5953aCA3D3188433413;
      
    address public tokenSaleFundVault = 0x22a7a88680bcfE1e932FD95d4F777fd927a5Bd8b;
   
        
    /* constructor - must supply a MiniMeTokenFactory address */
    function KISSES (address _tokenFactory) 
    public MiniMeToken(_tokenFactory,   // factory address
                        address(0x0),   // no parent token
                        0,              // no parent token snapshot block
                        "KISSES Token", // the glorious token name
                        decimalPlaces,  // five decimals 
                        "KISSES",       // token symbol
                        true)           // transfers enabled 
    {
      generateTokens(crowdsaleVault, crowdsaleVolume);
      
      generateTokens(ecosystemOneVault, ecosystemOneSupply);
      generateTokens(ecosystemTwoVault, ecosystemTwoSupply);
      
      generateTokens(legalOneVault, legalOneSupply);
      generateTokens(legalTwoVault, legalTwoSupply);
      
      generateTokens(bountyOneVault, bountyOneSupply);
      generateTokens(bountyTwoVault, bountyTwoSupply);
      
      generateTokens(reserveVault, reserveSupply);
      
      generateTokens(partnerOneVault, partnerOneSupply);
      generateTokens(partnerTwoVault, partnerTwoSupply);
      
      generateTokens(teamOneVault, teamOneSupply);
      generateTokens(teamTwoVault, teamTwoSupply);
      
      generateTokens(tokenSaleFundVault, tokenSaleFund);
             
      transferControl(0x0);
    }
        
}