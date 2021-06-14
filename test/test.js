const C = artifacts.require("C");

contract("C", (accounts) => {
  let contract;
  const num = 20;
  it("should return num 5", () =>
  C.deployed()
      .then((instance) => {
        contract = instance;
      })
      .then(()=>{
        return contract.approve(accounts[1], 10)
      })
      .then((r) => {
        return contract.allowance(accounts[0], accounts[1]);
      })
      .then((response) => {
        assert.equal(response.valueOf(), 10, "Error: " + response);
      })
      .then(
        () =>{
          return contract.transferFrom(accounts[1], accounts[0], accounts[3], 5)
        }
      )
      .then((r) => {
        return contract.allowance(accounts[0], accounts[1]);
      })
      .then(
        (response) =>{
          assert.equal(response.valueOf(), 5, "Error: " + response);
        }
      )
      
      
      );
});

