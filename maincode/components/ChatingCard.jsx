import React from "react";
import { Row, Card } from "react-bootstrap";
import 'bootstrap/dist/css/bootstrap.min.css';

export function CustomChatCard(props) {
    return (
        <Row style={{ marginLeft: "15px", marginBottom: "10px" }}>
            <Card border="primary" style={{ width: '100%', alignSelf: 'center', marginRight: "15px" }} onClick={() => { props.getMessages(props.publicKey); }}>
                <Card.Body>
                    <Card.Title>Friend: {props.name}</Card.Title>
                    <Card.Subtitle>
                        Public Key: {props.publicKey.length > 20 ? props.publicKey.substring(0, 20) + " ..." : props.publicKey}
                    </Card.Subtitle>
                </Card.Body>
            </Card>
        </Row>
    );
}
