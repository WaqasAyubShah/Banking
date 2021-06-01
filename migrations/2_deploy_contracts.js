const Borrow = artifacts.require("Borrow");

module.exports = function(deployer) {
  deployer.deploy(Borrow);
};
