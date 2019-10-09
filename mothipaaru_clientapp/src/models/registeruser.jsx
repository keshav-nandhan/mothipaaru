import React, { Component } from 'react'
import Modal from 'react-bootstrap/Modal'
import Button from 'react-bootstrap/Button'
class Register extends Component {
    render() {
        return (
            <Modal> <Modal.Dialog>
  <Modal.Header closeButton>
    <Modal.Title>Modal title</Modal.Title>
  </Modal.Header>

  <Modal.Body>
    <p>Modal body text goes here.</p>
  </Modal.Body>

  <Modal.Footer>
    <Button variant="light">Close</Button>
    <Button variant="light">Save changes</Button>
  </Modal.Footer>
</Modal.Dialog>
</Modal>
        )
    }
}
export default Register;