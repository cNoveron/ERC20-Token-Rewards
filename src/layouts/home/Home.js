import React, { Component } from 'react'
import { AccountData, ContractData, ContractForm } from 'drizzle-react-components'
import logo from '../../logo.png'

class Home extends Component {
  render() {
    return (
      <main className="container">
        <div className="pure-g">
          <div className="pure-u-1-1 header">
            <img src={logo} alt="drizzle-logo" />
            <h1>Pedro Token</h1>
            <p>This is a QA testing application for Pedro ERC20 Token.</p>

            <br/><br/>
          </div>

          <div className="pure-u-1-1">
            <h2>Active Account</h2>
            <AccountData accountIndex="0" units="ether" precision="3" />

            <br/><br/>
          </div>

          <div className="pure-u-1-1">
            <h2>TutorialToken</h2>
            <p></p>  
            <p>
              <strong>Total Supply: </strong>
                <ContractData 
                contract="TutorialToken" 
                method="totalSupply" 
                methodArgs={[{from: this.props.accounts[0]}]} 
              /> 
              <ContractData 
                contract="TutorialToken" 
                method="symbol" 
                hideIndicator 
              />
            </p>
            <p>
              <strong>My Balance: </strong>
              <ContractData 
                contract="TutorialToken" 
                method="balanceOf" 
                methodArgs={[this.props.accounts[0]]} 
              />
            </p>
            <h3>Send Tokens</h3>
              <ContractForm 
                contract="TutorialToken" 
                method="transfer" 
                labels={['To Address', 'Amount to Send']} 
              />
            <br/><br/>
          </div>
        </div>
      </main>
    )
  }
}

export default Home
