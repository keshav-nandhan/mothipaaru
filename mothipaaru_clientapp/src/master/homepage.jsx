import React, { Component } from 'react'
import Headernav from './headernav'
import Titlebar from './titlebar'
import Carouselcomponent from './carousel'
import Container from 'react-bootstrap/Container'
import Cards from './cards'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import Footer from './footer'
  class Homepage extends Component {
    render() {
        return (
            <div>
                <Titlebar/>
                <Carouselcomponent/>
                <div>
                    <Container>
                    <Row>
                        <Col><Cards/></Col>
                        <Col md={6}> <Headernav/></Col>
                        <Col><Cards/></Col>
                    </Row>
                    </Container>
                </div>
                <hr/>
                <Footer/>
            </div>
        )
    }
}
export default Homepage;