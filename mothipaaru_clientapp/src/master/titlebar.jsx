import React, { Component } from 'react'
import Container from 'react-bootstrap/Container'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'

 class Titlebar extends Component {
    render() {
        return (
            <Container>
  <Row className="justify-content-md-center">
    <Col xs lg="2">
      Title
    </Col>
    <Col md="auto">Variable width content</Col>
    <Col xs lg="2">
      3 of 3
    </Col>
  </Row>
  <Row>
    <Col>1 of 3</Col>
    <Col md="auto"></Col>
    <Col xs lg="2">
     Login
    </Col>
  </Row>
</Container>


        )
    }
}
     
export default Titlebar;