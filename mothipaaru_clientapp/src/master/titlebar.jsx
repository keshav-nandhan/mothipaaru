import React, { Component } from 'react'
import Container from 'react-bootstrap/Container'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import { BrowserRouter as Router, Route, Link } from 'react-router-dom';
import Register from '../models/registeruser'

 class Titlebar extends Component {
    render() {
        return (
          <div className="titlebar">
            <Container>
            <Row>
              <Col md={6}><p>Dummy Titile</p></Col>
              <Col md={{ span: 4, offset: 2 }}>
                <Router>
              <Link to={'/RegisterUser'} className="btn btn-primary" variant="light">Register</Link>
              <Route path='/RegisterUser' component={Register} />
              </Router>
              </Col>
            </Row>
          </Container>
          </div>

        )
    }
}
     
export default Titlebar;