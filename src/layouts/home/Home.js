import React, { Component } from 'react'
import { ContractData, ContractForm } from 'drizzle-react-components'
import BalanceRange from '../components/BalanceRange.js'
import Balance from '../components/Balance.js'
import logo from '../../logo.png'

class Home extends Component {
  constructor(props) {
    super(props);
    this.state = {
      fromAccount: {
        index: 0,
        address: this.props.accounts[0],
      },
    }
    this.changeIndex = this.changeIndex.bind(this);
  }

  changeIndex(event) {
    if(0 <= event.target.value && event.target.value < 10)
    this.setState({
      fromAccount: {
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
            <h2>Pedro Token</h2>
            <p></p>  
            <p>
              <strong>Total Supply: </strong>
              <ContractData 
                contract="Pedro_ERC20Token" 
                method="totalSupply" 
                methodArgs={[{from: this.props.accounts[0]}]} 
              />{" "}
              <ContractData 
                contract="Pedro_ERC20Token" 
                method="symbol" 
                hideIndicator 
              />
            </p>
            <BalanceRange 
              accountsToRetrieve={9} 
              passedAccounts={this.props.accounts} 
            />
            <h2>Cuenta actual</h2>
            <input 
              type="number" 
              value={this.state.fromAccount.index} 
              onChange={this.changeIndex}
            />
            <Balance addressStr={this.state.fromAccount.address} />
            <br/>
            <h3>Send Tokens</h3>
              <ContractForm 
                contract="Pedro_ERC20Token" 
                method="transfer" 
                labels={['To Address', 'Amount to Send']}
                sendArgs={{from: this.state.fromAccount.address}}
              />
            <br/><br/>
          </div>
        </div>
      </main>
    )
  }
}

export default Home
