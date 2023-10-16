import React from "react";
import { useState } from "react";
import { Button, Modal, Form } from "react-bootstrap";

export function CustomChatAdd(props) {
    const [showModal, setShowModal] = useState(false);
    const handleCloseModal = () => setShowModal(false);
    const handleShowModal = () => setShowModal(true);

    return (
        <div className="CustomChatAdd" style={{ position: "fixed", bottom: "20px", padding: "10px 45px 0 45px", margin: "0 95px 0 0", width: "90%" }}>
            <Button variant="info" className="mb-2" onClick={handleShowModal}>
                + New Chat
            </Button>
            <Modal show={showModal} onHide={handleCloseModal}>
                <Modal.Header closeButton>
                    <Modal.Title> Add New Friend </Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <Form.Group>
                        <Form.Control required id="customPublicKey" size="text" type="text" placeholder="Enter Friend's Public Key" />
                        <br />
                        <Form.Control required id="customName" size="text" type="text" placeholder="Name" />
                        <br />
                    </Form.Group>
                </Modal.Body>
                <Modal.Footer>
                    <Button variant="secondary" onClick={handleCloseModal}>
                        Close
                    </Button>
                    <Button variant="primary" onClick={() => {
                        props.addHandler(document.getElementById('customName').value, document.getElementById('customPublicKey').value);
                        handleCloseModal();
                    }}>
                        Add Friend
                    </Button>
                </Modal.Footer>
            </Modal>
        </div>
    );
}
