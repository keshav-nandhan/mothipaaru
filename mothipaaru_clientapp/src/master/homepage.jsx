import React, { Component } from 'react'
import Headernav from './headernav'
import Titlebar from './titlebar'

  class Homepage extends Component {
    render() {
        return (
            <div>
                <Titlebar/>
                <Headernav/>
                <span>This is home page</span>
                
            </div>
        )
    }
}
export default Homepage;