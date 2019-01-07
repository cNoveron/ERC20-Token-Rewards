import React, { Component } from 'react'
import { ContractData } from 'drizzle-react-components'

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
  }

  getColors(props) {
    this.colorStrings = {
      primary: props.currentAccount.substring(2, 8),
      secondary: props.currentAccount.substring(9, 15)
    }
  }

  componentDidUpdate(prevProps) {
    if (this.props !== prevProps) {
      this.getColors(this.props)
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
    return(
      <div>      
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