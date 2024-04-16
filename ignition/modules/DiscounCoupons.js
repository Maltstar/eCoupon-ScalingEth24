const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("DiscountCoupons", (m) => {
  const lock = m.contract("DiscountCoupons", ["0x8f5c6660D5c43001325ba0489dF09C971de7c8f7"], {});

  return { lock };
});
