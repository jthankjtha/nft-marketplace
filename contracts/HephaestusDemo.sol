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

    struct Loan{
        uint256 loanId;				
        address bankWalletAddress;
        address borrowerWalletAddress;
        uint256 tokenId;
        LoanState loanState;
    }

    uint private _loanId = 1000;
    //Store
    mapping(uint  => Loan) private _loanMapping;

    //Step-1 : OwnerOf/Verify : Customer
    //Step-2 : Apporve : Customer
    //Step-3 : Deposit NFT : Customer
    //Step-4 : Create Loan : Customer
    //Step-5 : Loan Close : Bank

    //Invoked By Bank when loan is approved/initilized
    //Add a record into mapping and update loan state
    function createLoan(address _bankWalletAddress,  address _borrowerWalletAddress, uint256 _tokenId)
    private 
    returns(uint)
    //onlyBank
    {  
        //increment the id
        Loan memory loan = Loan(
            ++_loanId,
            _bankWalletAddress,             //this will give the address automatically
            _borrowerWalletAddress, 
            _tokenId,
            LoanState.INITIALIZED
        );

        _loanMapping[_loanId] = loan;
        return _loanId;
    }


    //Customer deposits NFT to escrow contract
    function depositNFT(address _bankWalletAddress,address _borrowerWalletAddress,address _NFTAddress, uint256 tokenId)
    external
    {
        //validations    
        ERC721(_NFTAddress).safeTransferFrom(_borrowerWalletAddress, address(this), tokenId);
        uint256 _generatedLoanId = createLoan(_bankWalletAddress, _borrowerWalletAddress,tokenId);
        Loan storage loan = _loanMapping[_generatedLoanId];
        loan.loanState = LoanState.ACTIVE;
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

    //Invoked by Bank when loan is closed.
    function loanClose(address _NFTAddress, uint256 loanId)
    external
    {    
        //validations
        //require(_loanMapping[_loanId].loanState==LoanState.ACTIVE);
        Loan storage loan = _loanMapping[loanId];
        loan.loanState = LoanState.CLOSED;

        //transfer NFT back to user
        ERC721(_NFTAddress).safeTransferFrom(address(this), loan.borrowerWalletAddress, loan.tokenId);
    }



    
    /*
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
