#include "ChatCoreBridgeC.h"

struct ChatCoreHandle {
    bool authenticated{false};
};

ChatCoreHandle *chatcore_create(void)
{
    return new ChatCoreHandle();
}

void chatcore_destroy(ChatCoreHandle *handle)
{
    delete handle;
}

int chatcore_is_authenticated(ChatCoreHandle *handle)
{
    if (!handle)
    {
        return 0;
    }
    return handle->authenticated ? 1 : 0;
}
