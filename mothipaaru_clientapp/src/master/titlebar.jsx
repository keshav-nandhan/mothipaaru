import React, { Component } from 'react'
import Container from 'react-bootstrap/Container'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'

 class Titlebar extends Component {
    render() {
        return (
            <Container>
            <Row>
              <Col xs={6}>1</Col><Col xs={6}>2</Col>
            </Row>
            <Row>
              2
            </Row>
          </Container>


        )
    }
}
     
export default Titlebar;