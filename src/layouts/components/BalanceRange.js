import React, { Component } from 'react'
import { DrizzleContext } from 'drizzle-react'

// Components
import Balance from './Balance.js'
import _ from 'lodash'

class BalanceRange extends Component {

  render() {

    if (_.isEmpty(this.props.drizzleState.accounts))
      return (<div>503 - Service unavailable - BalanceRange:34 !this.props.drizzle.store.getState().accounts </div>)
    else
      return (
        <div>{
          _
          .range(0,this.props.accountsToRetrieve)
          .map(
            index => (
              <Balance
                drizzle={this.props.drizzle}
                drizzleState={this.props.drizzleState}
                index={index}
                key={index} />
            )
          )
        }</div>
      )
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
            accountsToRetrieve={props.accountsToRetrieve} />
        )
      }
    }
  </DrizzleContext.Consumer >
)