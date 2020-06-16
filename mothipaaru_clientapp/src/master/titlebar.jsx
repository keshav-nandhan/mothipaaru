import React, { Component } from 'react'
import Container from 'react-bootstrap/Container'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import Button from 'react-bootstrap/Button'
import Modal from 'react-bootstrap/Modal'

 class Titlebar extends Component {
    render() {
        return (
          <div className="titlebar">
            <div>
            <Row>
              <Col><p>Dummy Titile</p></Col>
              <Col xs={12}>
              <Button className="registerbtn">Register</Button>
              </Col>
              <Col></Col>

            </Row>
          </div>
         
          </div>

        )
    }
}
     
export default Titlebar;