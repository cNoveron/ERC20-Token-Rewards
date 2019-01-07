import React, { Component } from 'react'
import { DrizzleContext } from 'drizzle-react'

// Components
import Balance from './Balance.js'
import _ from 'lodash'

class BalanceRange extends Component {
  
  constructor(props) {
    super(props)
    this.state = props.state
  }

  componentDidUdpate(prevProps) {
    if (this.props !== prevProps)
      this.setState(this.props.state)
  }

  render() {

    if (_.isEmpty(this.state.drizzleState.accounts))
      return (<div>503 - Service unavailable - BalanceRange:34 !this.props.drizzle.store.getState().accounts </div>)
    else
      return (
        <div>{
          _
          .range(0,this.state.accountsToRetrieve)
          .map(
            index => (
              <Balance
                drizzle={this.state.drizzle}
                drizzleState={this.state.drizzleState}
                index={index}
                key={index}
                state={this.state} />
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
            state={props.state} />
        )
      }
    }
  </DrizzleContext.Consumer >
)