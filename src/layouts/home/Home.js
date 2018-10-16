import React, { Component } from 'react'
import { AccountData, ContractData, ContractForm } from 'drizzle-react-components'
import BalanceRange from '../components/BalanceRange.js'
import logo from '../../logo.png'

class Home extends Component {
  constructor(props) {
    super(props);
    this.state = {
      currentAccount: {
        index: 0,
        address: this.props.accounts[0],
      },
    }
    this.changeIndex = this.changeIndex.bind(this);
  }

  changeIndex(event) {
    if(event.target.value < 10)
    this.setState({
      currentAccount: {
        index: event.target.value,
        address: this.props.accounts[event.target.value],
      }
    })
  }

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
            <h2>Cuenta actual</h2>
            <div className="accountAddressString">
              <AccountData 
                accountIndex={""+this.state.currentAccount.index}  
                units="ether" 
                precision="3"
              />
            </div>
            <input 
              type="text" 
              value={this.state.currentAccount.index} 
              onChange={this.changeIndex} 
            />
          <br/><br/>
          </div>

          <div className="pure-u-1-1">
            <h2>Pedro Token</h2>
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
            <BalanceRange accountsToRetrieve={9}/>
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
