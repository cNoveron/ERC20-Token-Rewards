import React, { Component } from 'react'
import { ContractData } from 'drizzle-react-components'

class Balance extends Component {

  render() {
    return <p>
      <strong>balanceOf {this.props.addressStr} : </strong> 
      <ContractData 
        contract="Pedro_ERC20Token"
        method="balanceOf" 
        methodArgs={[this.props.addressStr]} 
      /> 
      <ContractData 
        contract="Pedro_ERC20Token"
        method="symbol"
      />
    </p>
  }
}

export default Balance