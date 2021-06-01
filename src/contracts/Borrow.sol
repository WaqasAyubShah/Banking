//Wiki was here...
pragma solidity 0.5.0;

contract Borrow {

  //Model a loan req
  struct Loan {
    uint id;
    uint amount;
    string reason;
    uint loan_duration_months;
    uint total_installments;
    uint installment_duration_months;
    uint interest_rate;
    uint amount_per_installment;
    uint principal_amount;
    uint balance;
    bool requested;
    bool granted;
    bool accepted;
    enum Status {Null, Requested, Granted}
    Status status;
  }

  address payable public borrower;
  address payable public lender;
  uint public loan_amount;

  enum Status {Null, Requested, Granted}
  // Status public status;

  //Fetch and Store Loan
  mapping(uint => Loan) public loans;

  //Store total number of loans
  uint loan_count;

  modifier onlyLender() {
    require(lender == msg.sender);
    _;
  }

  modifier onlyBorrower() {
    require(borrower == msg.sender);
    _;
  }

   modifier inState(Status _status) {
   // require(_id > 0 && _id <= loan_count);
     require(status == _status);
     _;
   }

  constructor() public {
    borrower = msg.sender;
    status = Status.Requested;
  }

   function reqLoan(uint _amount)
   public
   onlyBorrower
   inState(Status.Null)
   {
       //borrower = payable(msg.sender);
       loan_amount = _amount;
       status = Status.Requested;
   }

  function reqLoan(uint _amount, string memory _reason, uint _loan_duration_months, uint _total_installments)
  public
  onlyBorrower
  //inState(Status.Null)
  {
    // borrower = payable(msg.sender);
    loan_count++;
    require(loans[loan_count].status == Status.Null);
    loans[loan_count].principal_amount = _amount;
    loans[loan_count].reason = _reason;
    loans[loan_count].loan_duration_months = _loan_duration_months;
    loans[loan_count].total_installments = _total_installments;
    uint interest_amount = (loans[loan_count].principal_amount * loans[loan_count].interest_rate * loans[loan_count].loan_duration_months) / 1200;
    loans[loan_count].amount_per_installment = interest_amount / loans[loan_count].loan_duration_months;
    loans[loan_count].status = Status.Requested;
  }

  function grantLoan(uint _id)
  public
  // inState(Status.Requested)
  payable
  {
    require(loans[_id].status == Status.Requested);
    lender = msg.sender;
    borrower.transfer(loans[_id].principal_amount);
    loans[_id].status = Status.Granted;
  }

  function repayInstallment(uint _id, uint _amount)
  public
  payable
  // inState(Status.Granted)
  {
    require(loans[_id].status == Status.Requested);
    require(loans[_id].balance > 0 && _amount <= loans[_id].balance);
    lender.transfer(_amount);
    loans[_id].balance -= _amount;
  }






   function reqLoan (uint _amount, string memory _reason, uint _loan_duration_months, uint _total_installments) public{
     loan_count++;
     require(!loans[loan_count].requested, "Loan not requested "); // loan requested == false
     loans[loan_count].amount = _amount;
     loans[loan_count].reason = _reason;
     loans[loan_count].loan_duration_months = _loan_duration_months;
     loans[loan_count].total_installments = _total_installments;
     loans[loan_count].requested = true;
   }

   function grantLoan(uint _id) public{
     require(_id > 0 && _id <= loan_count);
     loans[_id].granted = true;
   }

   function acceptLoan(uint _id) public{
     require(_id > 0 && _id <= loan_count);
     loans[_id].accepted = true;
   }



}
