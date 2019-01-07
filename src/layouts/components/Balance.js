import React, { Component } from 'react'
import { DrizzleContext } from 'drizzle-react'

// Components
import { ContractData } from 'drizzle-react-components'
import _ from 'lodash'

class Balance extends Component {

  constructor(props) {
    super(props)
    this.colorStrings = {
      primary: props.state.currentAccount.substring(2, 8),
      secondary: props.state.currentAccount.substring(9, 15)
    }
    this.state = {
      ...props.state,
      address: {
        color: '#' + this.colorStrings.primary,
        display: 'inline'
      },
      balance: {
        color: 'white',
        fontWeight: 'bold',
        backgroundColor: '#' + this.colorStrings.secondary,
        padding: '3px 7px',
        borderRadius: '4px'
      },
    }
  }

  evaluateColors(currentAccount) {
    this.colorStrings = {
      primary: currentAccount.substring(2, 8),
      secondary: currentAccount.substring(9, 15)
    }
  }

  componentDidUpdate(prevProps) {
    if (this.props !== prevProps) {
      this.evaluateColors(this.props.currentAccount)
      this.setState({
        ...this.props.state,
        address: {
          color: '#' + this.colorStrings.primary,
          display: 'inline'
        },
        balance: {
          color: 'white',
          fontWeight: 'bold',
          backgroundColor: '#' + this.colorStrings.secondary,
          padding: '3px 7px',
          borderRadius: '4px'
        }
      })
    }
  }

  render() {

    if (_.isEmpty(this.props.currentAccount))
      return(<div>503 - Service unavailable - !this.props.currentAccount </div>)
    else
      return(
        <div>      
          balanceOf:{' '}
          <strong style={this.state.address}>
            {this.props.currentAccount}
          </strong>{' '}
          <div style={this.state.balance}>
            <ContractData
              drizzle={this.props.drizzle}
              drizzleState={this.props.drizzleState}
              contract="Pedro_ERC20Token"
              method="balanceOf" 
              methodArgs={[this.props.currentAccount]} />{' '}            
            <ContractData
              drizzle={this.props.drizzle}
              drizzleState={this.props.drizzleState}
              contract="Pedro_ERC20Token"
              method="symbol"
            />
          </div>
        </div>
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
          <Balance
            drizzle={drizzle}
            drizzleState={drizzleState}
            currentAccount={drizzleState.accounts[props.index]}
            index={props.index}
            state={props.state} />
        )
      }
    }
  </DrizzleContext.Consumer >
)