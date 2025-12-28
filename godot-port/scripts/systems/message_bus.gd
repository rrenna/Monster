## MessageBus - Global message passing system
## Ported from MMessage.h/mm and message queue in MEntityManager
extends Node

## Signal emitted when any message is sent
signal message_sent(message: Message)

## Queue of pending messages with delays
var _message_queue: Array[Message] = []


func _process(delta: float) -> void:
	_process_message_queue(delta)


## Queue a message for delivery (possibly with delay)
func queue_message(message: Message) -> void:
	if message.delay <= 0:
		_deliver_message(message)
	else:
		_message_queue.append(message)


## Send a message immediately (no delay)
func send_message(message: Message) -> void:
	_deliver_message(message)


## Process queued messages, decrementing delays
func _process_message_queue(delta: float) -> void:
	var messages_to_deliver: Array[Message] = []
	var remaining_messages: Array[Message] = []

	for msg in _message_queue:
		msg.delay -= delta
		if msg.delay <= 0:
			messages_to_deliver.append(msg)
		else:
			remaining_messages.append(msg)

	_message_queue = remaining_messages

	for msg in messages_to_deliver:
		_deliver_message(msg)


## Deliver a message to its recipient
func _deliver_message(message: Message) -> void:
	message_sent.emit(message)

	# If there's a specific receiver, try to find and notify them
	if message.receiver and message.receiver != "":
		var receiver_node = EntityManager.get_entity_by_name(message.receiver)
		if receiver_node and receiver_node.has_method("receive_message"):
			receiver_node.receive_message(message)


## Message data class
class Message:
	var sender: String
	var receiver: String
	var entity_type: int  # Enums.EntityType
	var message_type: int  # Enums.MessageType
	var value: Variant
	var delay: float

	func _init(
		p_sender: String = "",
		p_receiver: String = "",
		p_entity_type: int = Enums.EntityType.ANY,
		p_message_type: int = Enums.MessageType.UPDATE,
		p_value: Variant = null,
		p_delay: float = 0.0
	) -> void:
		sender = p_sender
		receiver = p_receiver
		entity_type = p_entity_type
		message_type = p_message_type
		value = p_value
		delay = p_delay
