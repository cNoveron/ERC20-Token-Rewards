import React, { Component } from 'react'
import { ContractData } from 'drizzle-react-components'

class Balance extends Component {

  render() {
    return <p>
      <strong>balanceOf {this.props.accountStr} : </strong> 
      <ContractData 
        contract="TutorialToken"
        method="balanceOf" 
        methodArgs={[this.props.accountStr]} 
      /> 
      <ContractData 
        contract="TutorialToken"
        method="symbol"
      />
    </p>
  }
}

export default Balance