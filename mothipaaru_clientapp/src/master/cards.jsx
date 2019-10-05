import React, { Component } from 'react'
import Card from 'react-bootstrap/Card'
class Cards extends Component {
    render() {
        return (
            <div>
                <Card style={{ width: 'auto' }}>
  <Card.Body>
    <Card.Title>Card Title</Card.Title>
    <Card.Subtitle className="text-muted">Card Subtitle</Card.Subtitle>
    <Card.Text>
      Some quick example text to build on the card title and make up the bulk of
      the card's content.
    </Card.Text>
    <Card.Link href="#">Card Link</Card.Link>
    <Card.Link href="#">Another Link</Card.Link>
  </Card.Body>
</Card>
            </div>
        )
    }
}
export default Cards;