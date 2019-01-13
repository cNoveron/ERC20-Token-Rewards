import React, { Component } from 'react'
import { DrizzleContext } from 'drizzle-react'

// Components
import { ContractForm } from 'drizzle-react-components'
import Balance from '../components/Balance.js'
import _ from 'lodash'

class BalanceSelect extends Component {

  constructor(props) {
    super(props)
    this.state = {
      currentAccount: props.drizzleState.accounts[0],
      index: 0,
    }
    this.changeIndex = this.changeIndex.bind(this)
  }

  changeIndex(event) {
    const { value } = event.target
    if (0 <= value && value < 10) {
      this.setState({
        currentAccount: this.props.drizzleState.accounts[value],
        index: value,
      })
    }
  }

  render() {
    if (_.isEmpty(this.props.drizzleState.accounts)) {
      return (
        <div>
          503 - Service unavailable - BalanceSelect.js: _.isEmpty(this.props.drizzleState.accounts)
        </div>
      )
    }
    else {
      return (
        <div className="container">
            <h2>Send tokens</h2>
            <h3>Select account index to send from</h3>
            <input
              type="number"
              value={this.state.index}
              onChange={this.changeIndex} />
            <h3>You will send tokens from this account</h3>
            <Balance
              drizzle={this.props.drizzle}
              drizzleState={this.props.drizzleState}
              index={this.state.index} />
            <br />
            <h3>Select account to send tokens to</h3>
            <ContractForm
              drizzle={this.props.drizzle}
              drizzleState={this.props.drizzleState}
              contract="Pedro_ERC20Token"
              method="transfer"
              labels={['To Address', 'Amount to Send']}
              sendArgs={{ from: this.state.currentAccount }} />
            <br /><br />
          </div>
      )
    }
  }
}

export default () => (
  <DrizzleContext.Consumer>
    {
      drizzleContext => {
        var drizzle = drizzleContext.drizzle
        var drizzleState = drizzle.store.getState()
        return (
          <BalanceSelect
            drizzle={drizzle}
            drizzleState={drizzleState} />
        )
      }
    }
  </DrizzleContext.Consumer >
)