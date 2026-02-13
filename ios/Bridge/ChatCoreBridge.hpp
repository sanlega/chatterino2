#pragma once

#include <string>
#include <vector>

namespace chatterino::ios {

struct Channel {
    std::string id;
    std::string name;
    int viewers{};
};

class ChatCoreBridge {
public:
    ChatCoreBridge();
    ~ChatCoreBridge();

    bool isAuthenticated() const;
    std::vector<Channel> fetchChannels() const;
    bool sendMessage(const std::string &channelId, const std::string &message) const;
};

}  // namespace chatterino::ios
