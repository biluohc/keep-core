package internal

import (
	"github.com/keep-network/keep-core/pkg/net"
)

// BasicMessage returns a struct-based trivial implementation of the net.Message
// interface for use by packages that don't need any frills.
func BasicMessage(
	transportSenderID net.TransportIdentifier,
	payload interface{},
	messageType string,
	senderPublicKey []byte,
	seqno uint64,
) net.Message {
	return &basicMessage{
		transportSenderID,
		payload,
		messageType,
		senderPublicKey,
		seqno,
	}
}

// basicMessage is a struct-based trivial implementation of the net.Message
// interface for use by packages that don't need any frills.
type basicMessage struct {
	transportSenderID net.TransportIdentifier
	payload           interface{}
	messageType       string
	senderPublicKey   []byte
	seqno             uint64
}

func (m *basicMessage) TransportSenderID() net.TransportIdentifier {
	return m.transportSenderID
}

func (m *basicMessage) Payload() interface{} {
	return m.payload
}

func (m *basicMessage) Type() string {
	return m.messageType
}

func (m *basicMessage) SenderPublicKey() []byte {
	return m.senderPublicKey
}

func (m *basicMessage) Seqno() uint64 {
	return m.seqno
}
