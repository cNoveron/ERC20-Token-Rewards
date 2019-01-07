import React, { Component } from 'react'
import { DrizzleContext } from 'drizzle-react'

// Components
import { ContractForm } from 'drizzle-react-components'
import BalanceRange from '../components/BalanceRange.js'
import Balance from '../components/Balance.js'
import _ from 'lodash'

import logo from '../../logo.png'

class Home extends Component {

  constructor(props) {
    super(props)
    this.state = {
      accounts: props.drizzleState.accounts,
      accountsToRetrieve: 4,
      currentAccount: null,
      drizzle: props.drizzle,
      drizzleState: props.drizzleState,
      index: 0,
      initialized: false
    }
    this.changeIndex = this.changeIndex.bind(this)
  }
  
  componentDidMount() {
    var Home = this
    this.unsubscribe = this.state.drizzle.store.subscribe(function () {

      /**
      * It's important to refresh drizzleState by calling
      * this method from drizzle.store, otherwise,
      * even though a change is observed in drizzle.store, 
      * drizzleState will remain the same 
      */
      var drizzle = Home.state.drizzle
      var drizzleState = drizzle.store.getState() 

      if (drizzleState.drizzleStatus.initialized) {
        
        Home.setState(prevState => {

          return {
            accounts: drizzleState.accounts,
            accountsToRetrieve: 4,
            currentAccount: drizzleState.accounts[prevState.index],
            drizzle: drizzle,
            drizzleState: drizzleState,
            index: prevState.index,
            initialized: true
          }

        })
      }

    })
  }

  componentWillUnmount() {
    this.unsubscribe()
  }

  changeIndex(event) {
    const { value } = event.target

    if (0 <= value && value < 10)
      this.setState(prevState => {
        
        return {
          ...prevState,
          index: value,
          currentAccount: this.state.accounts[value],
        }

      })
  }

  render() {

    if (_.isEmpty(drizzleState.accounts))
      return (<div>503 - Service unavailable - Home.js: _.isEmpty(this.state.drizzleState.accounts) </div>)
    else
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
                drizzle={this.props.drizzle}
                drizzleState={this.props.drizzle.store.getState()}
                state={this.state} />
            </div>
          </div>

          <div className="pure-u-1-2">
            <h2>Send tokens</h2>
            <h3>Select account index to send from</h3>
            <input 
              type="number" 
              value={this.state.index} 
              onChange={this.changeIndex} />
            <h3>You will send tokens from this account</h3>
            <Balance
              state={this.state}
              drizzle={this.state.drizzle}
              drizzleState={this.state.drizzleState}
              index={this.state.index} />
            <br/>
            <h3>Select account to send tokens to</h3>
            <ContractForm
              drizzle={this.state.drizzle}
              drizzleState={this.state.drizzleState}
              contract="Pedro_ERC20Token" 
              method="transfer" 
              labels={['To Address', 'Amount to Send']}
              sendArgs={{from: this.state.currentAccount}} />
            <br/><br/>
          </div>

        </div>
      )
  }
}

export default () => (
  <DrizzleContext.Consumer>
    {
      drizzleContext => {
        var drizzle = drizzleContext.drizzle
        var drizzleState = drizzle.store.getState()
        return (
          <Home
            drizzle={drizzle}
            drizzleState={drizzleState} />
        )
      }
    }
  </DrizzleContext.Consumer >
)