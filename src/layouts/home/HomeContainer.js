import Home from './Home'
import { drizzleConnect } from 'drizzle-react'

// May still need this even with data function to refresh component on updates for this contract.
const mapStateToProps = state => {
  return {
    accounts: state.accounts,
    Pedro_ERC20Token: state.contracts.Pedro_ERC20Token,
    drizzleStatus: state.drizzleStatus
  }
}

const HomeContainer = drizzleConnect(Home, mapStateToProps);

export default HomeContainer
