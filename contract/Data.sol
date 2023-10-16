// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract UniqueChatData {

    struct ChatUser {
        string chatName;
        FriendInfo[] friendsList;
    }

    struct FriendInfo {
        address friendAddress;
        string friendName;
    }

    struct ChatMessage {
        address sender;
        uint256 timestamp;
        string content;
    }

    mapping(address => ChatUser) users;
    mapping(bytes32 => ChatMessage[]) allChatMessages;

    function isUserRegistered(address userAddress) public view returns(bool) {
        return bytes(users[userAddress].chatName).length > 0;
    }

    function registerUser(string calldata chatName) external {
        require(!isUserRegistered(msg.sender), "User already exists!");
        require(bytes(chatName).length > 0, "Chat name cannot be empty!"); 
        users[msg.sender].chatName = chatName;
    }

    function getChatName(address userAddress) external view returns(string memory) {
        require(isUserRegistered(userAddress), "User is not registered!");
        return users[userAddress].chatName;
    }

    function addFriend(address friendAddress, string calldata friendName) external {
        require(isUserRegistered(msg.sender), "Create an account first!");
        require(isUserRegistered(friendAddress), "Friend is not registered!");
        require(msg.sender != friendAddress, "Users cannot add themselves as friends!");
        require(!areFriendsAlready(msg.sender, friendAddress), "These users are already friends!");

        _addFriend(msg.sender, friendAddress, friendName);
        _addFriend(friendAddress, msg.sender, users[msg.sender].chatName);
    }

    function areFriendsAlready(address userAddress1, address userAddress2) internal view returns(bool) {

        if(users[userAddress1].friendsList.length > users[userAddress2].friendsList.length)
        {
            address tmp = userAddress1;
            userAddress1 = userAddress2;
            userAddress2 = tmp;
        }

        for(uint i = 0; i < users[userAddress1].friendsList.length; ++i)
        {
            if(users[userAddress1].friendsList[i].friendAddress == userAddress2)
                return true;
        }
        return false;
    }

    function _addFriend(address userAddress, address friendAddress, string memory friendName) internal {
        FriendInfo memory newFriend = FriendInfo(friendAddress, friendName);
        users[userAddress].friendsList.push(newFriend);
    }

    function getMyFriendsList() external view returns(FriendInfo[] memory) {
        return users[msg.sender].friendsList;
    }

    function getUniqueChatCode(address userAddress1, address userAddress2) internal pure returns(bytes32) {
        if(userAddress1 < userAddress2)
            return keccak256(abi.encodePacked(userAddress1, userAddress2));
        else
            return keccak256(abi.encodePacked(userAddress2, userAddress1));
    }

    function sendMessageToFriend(address friendAddress, string calldata messageContent) external {
        require(isUserRegistered(msg.sender), "Create an account first!");
        require(isUserRegistered(friendAddress), "Friend is not registered!");
        require(areFriendsAlready(msg.sender, friendAddress), "You are not friends with the given user");

        bytes32 chatCode = getUniqueChatCode(msg.sender, friendAddress);
        ChatMessage memory newMessage = ChatMessage(msg.sender, block.timestamp, messageContent);
        allChatMessages[chatCode].push(newMessage);
    }

    function readMessagesWithFriend(address friendAddress) external view returns(ChatMessage[] memory) {
        bytes32 chatCode = getUniqueChatCode(msg.sender, friendAddress);
        return allChatMessages[chatCode];
    }
}
