import React, { Component } from 'react'
import { BrowserRouter as Router, Switch, Route, Link } from 'react-router-dom';
import Home from '../models/home'
import Profile from '../models/profile'
import About from '../models/about'
import Contact from '../models/contact'
class Headernav extends Component {
    render() {
        return (
            <Router>
            <div>
                <ul>
                    <li><Link to={'/'} className="nav-link">Home</Link></li>
                    <li><Link to={'/Profile'} className="nav-link">Profile</Link></li>
                    <li><Link to={'/Contact'} className="nav-link">Contact</Link></li>
                    <li><Link to={'/About'} className="nav-link">About</Link></li>
                </ul>
           
            <Switch>
            <Route exact path='/' component={Home} />
            <Route exact path='/Profile' component={Profile} />
            <Route path='/Contact' component={Contact} />
            <Route path='/About' component={About} />
        </Switch>
        </div>
        </Router>
        )
    }
}
export default Headernav;