#include "ChatCoreBridge.hpp"

namespace chatterino::ios {

ChatCoreBridge::ChatCoreBridge() = default;
ChatCoreBridge::~ChatCoreBridge() = default;

bool ChatCoreBridge::isAuthenticated() const
{
    // TODO(MVP): conectar con account/session real del core.
    return false;
}

std::vector<Channel> ChatCoreBridge::fetchChannels() const
{
    // TODO(MVP): conectar a proveedor real de canales.
    return {
        {"shroud", "shroud", 54231},
        {"ibai", "ibai", 81234},
    };
}

bool ChatCoreBridge::sendMessage(const std::string &channelId,
                                 const std::string &message) const
{
    (void)channelId;
    return !message.empty();
}

}  // namespace chatterino::ios
