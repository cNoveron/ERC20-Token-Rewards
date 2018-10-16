import React, { Component } from 'react'
import Balance from './Balance.js'
import _ from 'lodash'

class BalanceRange extends Component {

  render() {
    return <div>
      {_.range(0,this.props.maxRange).map(index =>(
        <Balance account={index}/>
      ))}
    </div>
  }
}

export default BalanceRange