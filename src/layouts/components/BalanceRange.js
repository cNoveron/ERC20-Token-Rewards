import React, { Component } from 'react'
import Balance from './Balance.js'
import _ from 'lodash'

class BalanceRange extends Component {

  render() {
    return <div>{
      _
      .range(0,this.props.accountsToRetrieve)
      .map(
        indexNum =>(
          <Balance
            drizzle={this.props.drizzle}
            drizzleState={this.props.drizzle.store.getState()}
            key={indexNum}
            currentAccount={this.props.passedAccounts[indexNum]} />
        )
      )
    }</div>
  }
}

export default (props) => (
  <DrizzleContext.Consumer>
    {
      drizzleContext => {
        var drizzle = drizzleContext.drizzle
        var drizzleState = drizzle.store.getState()
        return (
          <BalanceRange
            drizzle={drizzle}
            drizzleState={drizzleState}
            state={props.state} />
        )
      }
    }
  </DrizzleContext.Consumer >
)