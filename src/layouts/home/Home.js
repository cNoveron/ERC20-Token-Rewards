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
            <div className="pure-g">            
                <div className="pure-u-1 header">
                    <div className="container">
                        <img src={logo} alt="logo"/>
                        <h1>Pedro Token</h1>
                        <p>This is a QA testing application for Pedro ERC20 Token.</p>
                        <br/><br/>
                    </div>
                </div>
                <div className="pure-u-1-2">
                    <div className="container">
                        <h2>Balances</h2>
                        <BalanceRange 
                            accountsToRetrieve={4} 
                            passedAccounts={this.props.accounts} 
                        />
                    </div>
                </div>
                <div className="pure-u-1-2">
                    <h2>Send tokens</h2>
                    <h3>Select account index to send from</h3>
                    <input 
                        type="number" 
                        value={this.state.fromAccount.index} 
                        onChange={this.changeIndex}
                    />
                    <h3>You will send tokens from this account</h3>
                    <Balance 
                        addressStr={this.props.accounts[this.state.fromAccount.index]}
                    />
                    <br/>
                    <h3>Select account to send tokens to</h3>
                    <ContractForm 
                        contract="Pedro_ERC20Token" 
                        method="transfer" 
                        labels={['To Address', 'Amount to Send']}
                        sendArgs={{from: this.state.fromAccount.address}}
                    />
                    <br/><br/>
                </div>
            </div>
        )
    }
}

export default Home
