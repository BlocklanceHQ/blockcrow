import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox-viem/network-helpers";
import { expect } from "chai";
import hre from "hardhat";
import { getAddress, parseGwei } from "viem";

describe("ESCrow", function () {
  async function deployEscrowFixture() {
    const paymentToken = "0x0000000";
    const projectDID = "did:viem:123";
    const freelancer = "0x123";
    const milestones = [parseGwei("1"), parseGwei("2"), parseGwei("3")];

    const escrow = await hre.viem.deployContract("ESCrow", [
      paymentToken,
      projectDID,
      freelancer,
      milestones,
    ]);

    const publicClient = await hre.viem.getPublicClient();

    return {
      escrow,
      paymentToken,
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

      expect(await escrow.read.projectDID()).to.equal(projectDID);
    });

    it("Should set the right freelancer", async function () {
      const { escrow, freelancer } = await loadFixture(deployEscrowFixture);

      expect(await escrow.read.freelancer()).to.equal(freelancer);
    });
  });

  describe("Milestones", function () {
    it("Should set the right milestones", async function () {
      const { escrow, milestones } = await loadFixture(deployEscrowFixture);

      milestones.forEach(async (milestone, index) => {
        expect(await escrow.read.milestoneAmount(index + 1)).to.equal(
          milestone
        );
      });
    });
  });
});
