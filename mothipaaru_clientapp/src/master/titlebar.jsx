import React, { Component } from 'react'
import Container from 'react-bootstrap/Container'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import Button from 'react-bootstrap/Button'

 class Titlebar extends Component {
    render() {
        return (
          <div className="titlebar">
            <Container>
            <Row>
              <Col md={6}><p>Dummy Titile</p></Col>
              <Col md={{ span: 4, offset: 2 }}>
              <Button variant="light">Register</Button>
              </Col>
            </Row>
          </Container>
          </div>

        )
    }
}
     
export default Titlebar;