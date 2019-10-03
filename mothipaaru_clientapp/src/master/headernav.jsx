import React, { Component } from 'react'

class Headernav extends Component {
    render() {
        return (
            <div>
                <ul>
                    <li><a className="active" href="#home">Home</a></li>
                    <li><a href="#news">Profile</a></li>
                    <li><a href="#contact">Contact</a></li>
                    <li><a href="#about">About</a></li>
                </ul>
            </div>
        )
    }
}
export default Headernav;