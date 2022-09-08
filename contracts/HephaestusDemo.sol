/**
 * @file HephaestusDemo.sol
 * @author 
 * @date created 
 * @date last modified 
 */

//SPDX-License-Identifier: MIT
 
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract HephaestusDemo is IERC721Receiver {
    
    enum LoanState{INITIALIZED, NFTTRANSFERRED, APPROVED, ACTIVE, INACTIVE, CLOSED, DEFAULTED}

    //address payable public lenderWalletAddress;
    //address payable public borrowerWalletAddress;
    //address public nftAddress;
    //string tokenID;
    //uint256 loanId;
    //uint256 Id=0;
    //uint256 totalEmiPaid=0;
    //uint256 totalEmiExpected;
    //uint256 maxEMIToBeDefaulted;
    //bool customerCancel = false;
    //bool bankCancel = false;
    //LoanState public loanState;

    //empty constructor for now
    //constructor(){}

    struct Loan{
        uint256 loanId;				
        uint256 totalEmiPaid;
        uint256 totalEmiExpected;
        uint256 emiDefaulted;
        uint256 maxEMIToBeDefaulted;
        address lenderWalletAddress;
        address borrowerWalletAddress;
        uint256 tokenId;
        LoanState loanState;
    }

    Loan public loanRecord;
    uint private _loanId = 1000;
    //Store
    mapping(uint  => Loan) private _loanMapping;


    //Invoked By Bank when loan is approved/initilized
    // Add a record into mapping and update loan state
    function initializeLoan(uint256 _totalEmiExpected, uint256 _maxEMIToBeDefaulted, address _borrowerWalletAddress, uint256 _tokenId)
    external
    //onlyBank
    {  
        //increment the id
        Loan memory loan = Loan(
            ++_loanId,
            0,
            _totalEmiExpected,         
            0,
            _maxEMIToBeDefaulted, 
            msg.sender,             //this will give the address automatically
            _borrowerWalletAddress, 
            _tokenId,
            LoanState.INITIALIZED
        );

        _loanMapping[_loanId] = loan;
    }

    function getLoanDetail(uint256 _loanID) public view returns(Loan memory){  //view makes the operation completely free
        return _loanMapping[_loanID];
    }

    function getLoanState(uint _loanID) public view returns(string memory){  //view makes the operation completely free
        if (LoanState.INITIALIZED == _loanMapping[_loanID].loanState) return "Initialized";
        if (LoanState.NFTTRANSFERRED == _loanMapping[_loanID].loanState) return "NFT Transferred";
        if (LoanState.APPROVED == _loanMapping[_loanID].loanState) return "Approved";
        if (LoanState.ACTIVE == _loanMapping[_loanID].loanState) return "Active";
        if (LoanState.INACTIVE == _loanMapping[_loanID].loanState) return "Inactive";
        if (LoanState.CLOSED == _loanMapping[_loanID].loanState) return "Closed";
        if (LoanState.DEFAULTED == _loanMapping[_loanID].loanState) return "Defaulted";

        return "Not Found";
    }

    function onERC721Received( address operator, address from, uint256 tokenId, bytes calldata data ) public override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    /*function verifyToken(address account, uint256 tokenId) 
    public 
    view 
    returns(bool)    
    {
        address tokenOwner = ERC721(account).ownerOf(tokenId);
        
    }

    function depositNFT(address _NFTAddress, uint256 tokenId)
        public
        inLoanState(LoanState.APPROVED)
        onlyBorrower
    {
        //nftAddress = _NFTAddress;
        //tokenID = _TokenID;
        //ERC721(nftAddress).safeTransferFrom(msg.sender, address(this), tokenID);
        //projectState = ProjectState.nftDeposited;
        //loan state ?
    }

    
    
    function transferNFTBackToCustomer()
        public
        payable
        inLoanState(LoanState.CLOSED)
    {
        borrowerWalletAddress = payable(msg.sender);
        //Change the state
    }

    //Return state of loan by load ID
    function getLoanState(uint256 _loanId) 
    public
    view
    return (LoanState)
    {
        return loanRecord[_loanId].state;
    }

    function setLoanState(LoanState _loanState) 
    public
    onlyBank
    {
        loanState=_loanState;
    }

	modifier inLoanState(LoanState _state) {
		require(loanState == _state);
		_;
	}
    
   	modifier condition(bool _condition) {
		require(_condition);
		_;
	}

	modifier onlyBorrower() {
		require(msg.sender == borrowerWalletAddress);
		_;
	}

	modifier onlyLender() {
		require(msg.sender == lenderWalletAddress);
		_;
	}
	
    function getBalance()
        public
        view
        returns (uint256 balance)
    {
        return address(this).balance;
    }

    */
} 
