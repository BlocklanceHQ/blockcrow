import { loadFixture } from "@nomicfoundation/hardhat-toolbox-viem/network-helpers";
import { expect } from "chai";
import hre from "hardhat";
import { getAddress, parseGwei, parseEther } from "viem";

describe("BlockCrow", function () {
  async function deployEscrowFixture() {
    const projectDID =
      "did:key:z6MkfwvDtqRQ7ADgrUxQoA9coSFpoo58esRvSwc7ejA4zbR8";
    const [
      freelancer,
      { account: paymentToken },
    ] = await hre.viem.getWalletClients();
    const milestones = [parseGwei("1")];

    const escrow = await hre.viem.deployContract("BlockCrow", [
      getAddress(paymentToken.address),
      projectDID,
      getAddress(freelancer.account.address),
      milestones,
    ]);

    const publicClient = await hre.viem.getPublicClient();

    return {
      escrow,
      paymentToken: getAddress(paymentToken.address),
      projectDID,
      freelancer,
      milestones,
      publicClient,
    };
  }

  describe("Deployment", function () {
    it("Should set the right paymentToken", async function () {
      const { escrow, paymentToken } = await loadFixture(deployEscrowFixture);

      expect(await escrow.read.paymentToken()).to.equal(paymentToken);
    });

    it("Should set the right projectDID", async function () {
      const { escrow, projectDID } = await loadFixture(deployEscrowFixture);

      expect((await escrow.read.project())[0]).to.equal(projectDID);
    });

    it("Should set the right freelancer", async function () {
      const { escrow, freelancer } = await loadFixture(deployEscrowFixture);

      expect((await escrow.read.project())[1]).to.equal(
        getAddress(freelancer.account.address)
      );
    });
  });

  describe("Milestones", function () {
    it("Should set the right milestones", async function () {
      const { escrow, milestones } = await loadFixture(deployEscrowFixture);

      expect(await escrow.read.totalMilestones()).to.equal(milestones.length);
    });

    it("Should set the right milestone", async function () {
      const { escrow, milestones } = await loadFixture(deployEscrowFixture);

      expect(await escrow.read.milestones(0)).to.equal(milestones[0]);
    });
  });

  describe("Balance", function () {
    it("Should set the right balance", async function () {
      const { escrow, milestones } = await loadFixture(deployEscrowFixture);

      expect(await escrow.read.balanceOf()).to.equal(milestones[0]);
    });
  });
});
