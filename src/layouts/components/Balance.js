import React, { Component } from 'react'
import { ContractData } from 'drizzle-react-components'

class Balance extends Component {
  render() {
    let addressStyle = {
      color: "#"+this.props.addressStr.substring(2,8),
      display: 'inline',
    }
    let balanceStyle = {
      color: 'white',
      fontWeight: 'bold',
      backgroundColor: addressStyle.color,
      padding: '3px 7px',
      borderRadius: '4px' 
    }
    return <div>      
      balanceOf:{' '}
        <strong style={this.state.address}>
          {this.props.currentAccount}
      </strong>{' '}
        <div style={this.state.balance}>
        <ContractData 
            drizzle={this.props.drizzle}
            drizzleState={this.props.drizzle.store.getState()}
          contract="Pedro_ERC20Token"
          method="balanceOf" 
            methodArgs={[this.props.currentAccount]} 
        />{' '}
        <ContractData
            drizzle={this.props.drizzle}
            drizzleState={this.props.drizzle.store.getState()}
          contract="Pedro_ERC20Token"
          method="symbol"
        />
      </div>
    </div>
    )
  }
}

export default Balance