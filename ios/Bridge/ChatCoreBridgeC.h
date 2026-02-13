#pragma once

#ifdef __cplusplus
extern "C" {
#endif

typedef struct ChatCoreHandle ChatCoreHandle;

ChatCoreHandle *chatcore_create(void);
void chatcore_destroy(ChatCoreHandle *handle);
int chatcore_is_authenticated(ChatCoreHandle *handle);

#ifdef __cplusplus
}
#endif
