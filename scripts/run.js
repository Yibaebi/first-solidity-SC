const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners()

  // Get Contract Factory
  const waveContractFactory = await hre.ethers.getContractFactory('WavePortal')

  // Deploy contract
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther('0.1'),
  })

  // Wait for its deployment
  await waveContract.deployed()

  console.log('Contract was deployed to: ', waveContract.address)
  console.log('Contract was deployed by: ', owner.address)

  /*
   * Get Contract balance
   */

  let contractBalance = await hre.ethers.provider.getBalance(waveContract.address)

  let waveTxn1 = await waveContract.waveAtMe('I am Elliot and I just waved!')
  await waveTxn1.wait()

  let waveTxn2 = await waveContract.connect(randomPerson).waveAtMe('I am Kachi and I just waved!')
  await waveTxn2.wait()

  let lastWavedAddress = await waveContract.getLastWavedAddress()
  let lastLuckyWinner = await waveContract.getLastLuckyWinner()
  let lastWavedTime = await waveContract.getLastWavedTime()

  /*
   * Get Contract balance to see what happened!
   */
  contractBalance = await hre.ethers.provider.getBalance(waveContract.address)
  console.log('New Contract balance:', hre.ethers.utils.formatEther(contractBalance))

  allWavesData = await waveContract.getAllWavesData()
  console.log('All waves data', allWavesData)
}

const runMain = async () => {
  try {
    await main()
    process.exit(0)
  } catch (error) {
    console.log(error)
    process.exit(1)
  }
}

runMain()
