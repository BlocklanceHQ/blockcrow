# BlockCrow Escrow Smart Contract
> A decentralized escrow smart contract template for freelance projects on Blocklance.


## Overview

## Features

### 1. Project Information

Utilizes a Decentralized Identifier (DID) to reference project information stored on Blocklance. The smart contract ensures data integrity and security.

### 2. Payment Terms

BlockCrow also includes a secure payment structure allowing various payment methods, primarily any valid ERC20 token. Payouts can be made via different payment models such as hourly rates, fixed fees, or milestone-based payments.

### 3. Milestones

BlockCrow includes the ability to handle project milestones. Each milestone is represented by a unique ID which must have been created on Blocklance, and the associated amount for each milestone is securely stored on the contract. The contract allows flexibility in the number and structure of milestones.

### 4. Completion and Release of Funds

BlockCrow includes a secure process for releasing funds from escrow upon project completion, incorporating verification processes suitable for different project types. Safety checks are implemented to prevent unauthorized fund release.

### 5. Timeline

BlockCrow allows a flexible timeline structure using block timestamps to manage project durations, milestones, and final delivery dates securely.

## Usage

1. **Deployment**

   Deploy the smart contract to the Base blockchain.

2. **Initialization**

   Initialize the smart contract with the project information and payment terms.

3. **Escrow Agent**

   Assign an escrow agent to the project.

## Development

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.ts
```

## Dependencies

- OpenZeppelin Contracts Library: [GitHub](https://github.com/OpenZeppelin/openzeppelin-contracts)
- Hardhat: [GitHub](https://github.com/NomicFoundation/hardhat) | [Documentation](https://hardhat.org/getting-started/)

## Security Considerations

- Use access control mechanisms to restrict functions based on user roles.
- Thoroughly test the contract in a development environment before deploying it on the mainnet.
- Regularly update dependencies to benefit from security patches and improvements.

## License

This smart contract is released under the MIT License. See [LICENSE](./LICENSE.md) for more details.
