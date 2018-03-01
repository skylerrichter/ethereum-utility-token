var Consortium = artifacts.require("./Consortium.sol");
var Crowdsale = artifacts.require("./Crowdsale.sol");
var Token = artifacts.require("./Token.sol");

module.exports = function(deployer) {
  deployer.deploy(Consortium).then(() => {
    return deployer.deploy(Token, 500).then(() => {
      return deployer.deploy(
        Crowdsale, 
        Consortium.address,
        100,
        20,
        1,
        Token.address
      )
    });
  });
};
