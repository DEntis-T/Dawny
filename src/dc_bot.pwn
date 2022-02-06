/*
 * 
 * Dawny
 *
 * Since 2022., DEntisT
 *
 *
 *
 * - Discord Bot 
 *   written in Pawn
 *
 *
 */


#include <a_samp>
#include <sscanf2>

#tryinclude <discord-connector>

#if !defined dcconnector_included

/* Discord Connector
 * Version @DCC_VERSION@
 * made by maddinat0r
 */


#if defined dcconnector_included
    #endinput
#endif
#define dcconnector_included

// OVAJ PLUGIN JE NEOPHODAN ZA FUNKCIONALNOST.

enum DCC_ChannelType
{
    GUILD_TEXT = 0,
    DM = 1,
    GUILD_VOICE = 2,
    GROUP_DM = 3,
    GUILD_CATEGORY = 4
};

enum DCC_UserPresenceStatus
{
    INVALID = 0,
    ONLINE = 1,
    IDLE = 2,
    DO_NOT_DISTURB = 3,
    OFFLINE = 4
};

enum DCC_BotPresenceStatus
{
    INVALID = 0,
    ONLINE,
    IDLE,
    DO_NOT_DISTURB,
    INVISIBLE,
    OFFLINE
};

enum DCC_MessageReactionType
{
    REACTION_ADD = 0, // Sent when a user adds a reaction to a message.
    REACTION_REMOVE, // Sent when a user removes a reaction from a message.
    REACTION_REMOVE_ALL, // Sent when a user explicitly removes all reactions from a message.
    REACTION_REMOVE_EMOJI // Sent when a bot removes all instances of a given emoji from the reactions of a message.
};

#define DCC_INVALID_CHANNEL DCC_Channel:0
#define DCC_INVALID_USER DCC_User:0
#define DCC_INVALID_ROLE DCC_Role:0
#define DCC_INVALID_GUILD DCC_Guild:0

#define DCC_ID_SIZE (20 + 1)
#define DCC_USERNAME_SIZE (32 + 1)
#define DCC_NICKNAME_SIZE (32 + 1)
#define DCC_EMOJI_NAME_SIZE (32 + 1)

native DCC_Channel:DCC_FindChannelByName(const channel_name[]);
native DCC_Channel:DCC_FindChannelById(const channel_id[]);

native DCC_GetChannelId(DCC_Channel:channel, dest[DCC_ID_SIZE], max_size = sizeof dest);
native DCC_GetChannelType(DCC_Channel:channel, &DCC_ChannelType:type);
native DCC_GetChannelGuild(DCC_Channel:channel, &DCC_Guild:guild);
native DCC_GetChannelName(DCC_Channel:channel, dest[], max_size = sizeof dest);
native DCC_GetChannelTopic(DCC_Channel:channel, dest[], max_size = sizeof dest);
native DCC_GetChannelPosition(DCC_Channel:channel, &position);
native DCC_IsChannelNsfw(DCC_Channel:channel, &bool:is_nsfw);
native DCC_GetChannelParentCategory(DCC_Channel:channel, &DCC_Channel:category);

native DCC_SendChannelMessage(DCC_Channel:channel, const message[], const callback[] = "", const format[] = "", {Float, _}:...);
native DCC_SetChannelName(DCC_Channel:channel, const name[]);
native DCC_SetChannelTopic(DCC_Channel:channel, const topic[]);
native DCC_SetChannelPosition(DCC_Channel:channel, position);
native DCC_SetChannelNsfw(DCC_Channel:channel, bool:is_nsfw);
native DCC_SetChannelParentCategory(DCC_Channel:channel, DCC_Channel:parent_category);
native DCC_DeleteChannel(DCC_Channel:channel);

native DCC_GetMessageId(DCC_Message:message, dest[DCC_ID_SIZE], max_size = DCC_ID_SIZE);
native DCC_GetMessageChannel(DCC_Message:message, &DCC_Channel:channel);
native DCC_GetMessageAuthor(DCC_Message:message, &DCC_User:author);
native DCC_GetMessageContent(DCC_Message:message, dest[], max_size = sizeof dest);
native DCC_IsMessageTts(DCC_Message:message, &bool:is_tts);
native DCC_IsMessageMentioningEveryone(DCC_Message:message, &bool:mentions_everyone);
native DCC_GetMessageUserMentionCount(DCC_Message:message, &mentioned_user_count);
native DCC_GetMessageUserMention(DCC_Message:message, offset, &DCC_User:mentioned_user);
native DCC_GetMessageRoleMentionCount(DCC_Message:message, &mentioned_role_count);
native DCC_GetMessageRoleMention(DCC_Message:message, offset, &DCC_Role:mentioned_role);

native DCC_DeleteMessage(DCC_Message:message);

native DCC_Message:DCC_GetCreatedMessage(); // for use in DCC_SendChannelMessage result callback

native DCC_DeleteInternalMessage(DCC_Message:message); // This deletes a stored message, this DOES NOT delete it on discord, this is for persistent messages.

native DCC_EditMessage(DCC_Message:message, const content[], DCC_Embed:embed = DCC_Embed:0);

native DCC_SetMessagePersistent(DCC_Message:message, bool:persistent);
native DCC_CacheChannelMessage(const channel_id[DCC_ID_SIZE], const message_id[DCC_ID_SIZE], const callback[] = "", const format[] = "", {Float, _}:...);

native DCC_User:DCC_FindUserByName(const user_name[], const user_discriminator[]);
native DCC_User:DCC_FindUserById(const user_id[]);

native DCC_GetUserName(DCC_User:user, dest[DCC_USERNAME_SIZE], max_size = sizeof dest);
native DCC_GetUserId(DCC_User:user, dest[DCC_ID_SIZE], max_size = DCC_ID_SIZE);
native DCC_GetUserDiscriminator(DCC_User:user, dest[], max_size = sizeof dest);
native DCC_IsUserBot(DCC_User:user, &bool:is_bot);
native DCC_IsUserVerified(DCC_User:user, &bool:is_verified);

native DCC_Role:DCC_FindRoleByName(DCC_Guild:guild, const role_name[]);
native DCC_Role:DCC_FindRoleById(const role_id[]);

native DCC_GetRoleId(DCC_Role:role, dest[DCC_ID_SIZE], max_size = sizeof dest);
native DCC_GetRoleName(DCC_Role:role, dest[], max_size = sizeof dest);
native DCC_GetRoleColor(DCC_Role:role, &color);
native DCC_GetRoleColour(DCC_Role:role, &colour) = DCC_GetRoleColor; // for our British mates
native DCC_GetRolePermissions(DCC_Role:role, &perm_high, &perm_low); // 64 bit integer
native DCC_IsRoleHoist(DCC_Role:role, &bool:is_hoist);
native DCC_GetRolePosition(DCC_Role:role, &position);
native DCC_IsRoleMentionable(DCC_Role:role, &bool:is_mentionable);

native DCC_Guild:DCC_FindGuildByName(const guild_name[]);
native DCC_Guild:DCC_FindGuildById(const guild_id[]);

native DCC_GetGuildId(DCC_Guild:guild, dest[DCC_ID_SIZE], max_size = sizeof dest);
native DCC_GetGuildName(DCC_Guild:guild, dest[], max_size = sizeof dest);
native DCC_GetGuildOwnerId(DCC_Guild:guild, dest[DCC_ID_SIZE], max_size = sizeof dest);
native DCC_GetGuildRole(DCC_Guild:guild, offset, &DCC_Role:role);
native DCC_GetGuildRoleCount(DCC_Guild:guild, &count);
native DCC_GetGuildMember(DCC_Guild:guild, offset, &DCC_User:user);
native DCC_GetGuildMemberCount(DCC_Guild:guild, &count);
native DCC_GetGuildMemberVoiceChannel(DCC_Guild:guild, DCC_User:user, &DCC_Channel:channel);
native DCC_GetGuildMemberNickname(DCC_Guild:guild, DCC_User:user, dest[DCC_NICKNAME_SIZE], max_size = sizeof dest);
native DCC_GetGuildMemberRole(DCC_Guild:guild, DCC_User:user, offset, &DCC_Role:role);
native DCC_GetGuildMemberRoleCount(DCC_Guild:guild, DCC_User:user, &count);
native DCC_HasGuildMemberRole(DCC_Guild:guild, DCC_User:user, DCC_Role:role, &bool:has_role);
native DCC_GetGuildMemberStatus(DCC_Guild:guild, DCC_User:user, &DCC_UserPresenceStatus:status);
native DCC_GetGuildChannel(DCC_Guild:guild, offset, &DCC_Channel:channel);
native DCC_GetGuildChannelCount(DCC_Guild:guild, &count);
native DCC_GetAllGuilds(DCC_Guild:dest[], max_size = sizeof dest);

native DCC_SetGuildName(DCC_Guild:guild, const name[]);
native DCC_CreateGuildChannel(DCC_Guild:guild, const name[], DCC_ChannelType:type, const callback[] = "", const format[] = "", {Float, _}:...);
native DCC_Channel:DCC_GetCreatedGuildChannel();
native DCC_SetGuildMemberNickname(DCC_Guild:guild, DCC_User:user, const nickname[]);
native DCC_SetGuildMemberVoiceChannel(DCC_Guild:guild, DCC_User:user, DCC_Channel:channel);
native DCC_AddGuildMemberRole(DCC_Guild:guild, DCC_User:user, DCC_Role:role);
native DCC_RemoveGuildMemberRole(DCC_Guild:guild, DCC_User:user, DCC_Role:role);
native DCC_RemoveGuildMember(DCC_Guild:guild, DCC_User:user); // kicks the user from the server
native DCC_CreateGuildMemberBan(DCC_Guild:guild, DCC_User:user, const reason[] = "");
native DCC_RemoveGuildMemberBan(DCC_Guild:guild, DCC_User:user);
native DCC_SetGuildRolePosition(DCC_Guild:guild, DCC_Role:role, position);
native DCC_SetGuildRoleName(DCC_Guild:guild, DCC_Role:role, const name[]);
native DCC_SetGuildRolePermissions(DCC_Guild:guild, DCC_Role:role, perm_high, perm_low);
native DCC_SetGuildRoleColor(DCC_Guild:guild, DCC_Role:role, color);
native DCC_SetGuildRoleHoist(DCC_Guild:guild, DCC_Role:role, bool:hoist);
native DCC_SetGuildRoleMentionable(DCC_Guild:guild, DCC_Role:role, bool:mentionable);
native DCC_CreateGuildRole(DCC_Guild:guild, const name[], const callback[] = "", const format[] = "", {Float, _}:...);
native DCC_Role:DCC_GetCreatedGuildRole();
native DCC_DeleteGuildRole(DCC_Guild:guild, DCC_Role:role);

native DCC_BotPresenceStatus:DCC_GetBotPresenceStatus();

native DCC_TriggerBotTypingIndicator(DCC_Channel:channel);
native DCC_SetBotNickname(DCC_Guild:guild, const nickname[]);
stock DCC_ClearBotNickname(DCC_Guild:guild)
{
    return DCC_SetBotNickname(guild, "");
}
native DCC_CreatePrivateChannel(DCC_User:user, const callback[], const format[] = "", {Float, _}:...);
native DCC_Channel:DCC_GetCreatedPrivateChannel();
native DCC_SetBotPresenceStatus(DCC_BotPresenceStatus:status);
native DCC_SetBotActivity(const name[]);
stock DCC_ClearBotActivity()
{
    return DCC_SetBotActivity("");
}

native DCC_EscapeMarkdown(const src[], dest[], max_size = sizeof dest);

native DCC_Embed:DCC_CreateEmbed(const title[] = "", const description[] = "", const url[] = "", const timestamp[] = "", color = 0, const footer_text[] = "", const footer_icon_url[] = "", const thumbnail_url[] = "", const image_url[] = "");
native DCC_DeleteEmbed(DCC_Embed:embed);
native DCC_SendChannelEmbedMessage(DCC_Channel:channel, DCC_Embed:embed, const message[] = "", const callback[] = "", const format[] = "", {Float, _}:...);
native DCC_AddEmbedField(DCC_Embed:embed, const name[], const value[], bool:inline = false);
native DCC_SetEmbedTitle(DCC_Embed:embed, const title[]);
native DCC_SetEmbedDescription(DCC_Embed:embed, const description[]);
native DCC_SetEmbedUrl(DCC_Embed:embed, const url[]);
native DCC_SetEmbedTimestamp(DCC_Embed:embed, const timestamp[]);
native DCC_SetEmbedColor(DCC_Embed:embed, color);
native DCC_SetEmbedColour(DCC_Embed:embed, colour) = DCC_SetEmbedColor; // oi m8
native DCC_SetEmbedFooter(DCC_Embed:embed, const footer_text[], const footer_icon_url[] = "");
native DCC_SetEmbedThumbnail(DCC_Embed:embed, const thumbnail_url[]);
native DCC_SetEmbedImage(DCC_Embed:embed, const image_url[]);

native DCC_Emoji:DCC_CreateEmoji(const name[DCC_EMOJI_NAME_SIZE], const snowflake[DCC_ID_SIZE] = "");
native DCC_DeleteEmoji(DCC_Emoji:emoji);
native DCC_GetEmojiName(DCC_Emoji:emoji, dest[DCC_EMOJI_NAME_SIZE], maxlen = DCC_EMOJI_NAME_SIZE);

native DCC_CreateReaction(DCC_Message:message, DCC_Emoji:reaction_emoji);
native DCC_DeleteMessageReaction(DCC_Message:message, DCC_Emoji:reaction_emoji = DCC_Emoji:0); // if reaction_emoji is 0 (default value) this will delete ALL of the reactions on the message.

forward DCC_OnChannelCreate(DCC_Channel:channel);
forward DCC_OnChannelUpdate(DCC_Channel:channel);
forward DCC_OnChannelDelete(DCC_Channel:channel);

forward DCC_OnMessageCreate(DCC_Message:message);
forward DCC_OnMessageDelete(DCC_Message:message);
forward DCC_OnMessageReaction(DCC_Message:message, DCC_User:reaction_user, DCC_Emoji:emoji, DCC_MessageReactionType:reaction_type);

forward DCC_OnUserUpdate(DCC_User:user);

forward DCC_OnGuildCreate(DCC_Guild:guild);
forward DCC_OnGuildUpdate(DCC_Guild:guild);
forward DCC_OnGuildDelete(DCC_Guild:guild);

forward DCC_OnGuildMemberAdd(DCC_Guild:guild, DCC_User:user);
forward DCC_OnGuildMemberUpdate(DCC_Guild:guild, DCC_User:user);
forward DCC_OnGuildMemberVoiceUpdate(DCC_Guild:guild, DCC_User:user, DCC_Channel:channel);
forward DCC_OnGuildMemberRemove(DCC_Guild:guild, DCC_User:user);

forward DCC_OnGuildRoleCreate(DCC_Guild:guild, DCC_Role:role);
forward DCC_OnGuildRoleUpdate(DCC_Guild:guild, DCC_Role:role);
forward DCC_OnGuildRoleDelete(DCC_Guild:guild, DCC_Role:role);

#endif

#tryinclude <discord-command>

#if !defined _discordcmd_included

// OVO JE 'PLUGIN' ZA KOMANDE by ALILOGIC

#if defined _discordcmd_included
    #endinput
#endif
#define _discordcmd_included


#if !defined isnull
    #define isnull(%1) ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif

// Config

#define MAX_CMD_LEN         32
#define MAX_CMD_NAME        20

// Prefix

#if !defined CMD_PREFIX
    #define CMD_PREFIX      '-'
#endif

// Makrofunkcije

#define discord_%0\32; discord_

#define DISCORD:%1(%2)      \
    forward discord_%1(%2); \
    public discord_%1(%2)

#define DC:%1(%2)           \
    DISCORD:%1(%2)

// returnanje

#define DISCORD_SUCCESS     (1)
#define DISCORD_FAILURE     (0)

// KOD
public DCC_OnMessageCreate(DCC_Message: message) {

    new
        DCC_User: author,
        bool: is_bot = false,
        content[256 + MAX_CMD_NAME + 2],
        command[MAX_CMD_NAME],
        params[256],
        discord[MAX_CMD_LEN] = "discord_"
    ;

    if (!DCC_GetMessageAuthor(message, author) || author == DCC_INVALID_USER) { // The message author is invalid
        #if defined discdcmd_DCC_OnMessageCreate
            return discdcmd_DCC_OnMessageCreate(DCC_Message: message);
        #else
            return 0;
        #endif
    }

    DCC_IsUserBot(author, is_bot);
    DCC_GetMessageContent(message, content);

    if (is_bot || content[0] != CMD_PREFIX) { // Skip if the message author is a bot or is not a command
        #if defined discdcmd_DCC_OnMessageCreate
            return discdcmd_DCC_OnMessageCreate(DCC_Message: message);
        #else
            return 0;
        #endif
    }

    if (sscanf(content, "s["#MAX_CMD_NAME"]S()[256]", command, params)) {
        #if defined discdcmd_DCC_OnMessageCreate
            return discdcmd_DCC_OnMessageCreate(DCC_Message: message);
        #else
            return 0;
        #endif
    }

    for (new i = strlen(command) - 1; i != 0; i --) {
        command[i] |= 0x20; // lower case using bitwise OR operator
    }

    strcat(discord, command[1]);

    if (isnull(params)) {
        params = "\1";
    }

    #if defined OnDiscordCommandPerformed
        OnDiscordCommandPerformed(message, author, bool: CallLocalFunction(discord, "iis", _: message, _: author, params));
    #else
        CallLocalFunction(discord, "iis", _: message, _: author, params);
    #endif
    
    #if defined discdcmd_DCC_OnMessageCreate
        return discdcmd_DCC_OnMessageCreate(DCC_Message: message);
    #else
        return 1;
    #endif
}

// Hooking and functions

#if defined _ALS_DCC_OnMessageCreate
    #undef DCC_OnMessageCreate
#else
    #define _ALS_DCC_OnMessageCreate
#endif

#define DCC_OnMessageCreate discdcmd_DCC_OnMessageCreate
#if defined discdcmd_DCC_OnMessageCreate
    forward discdcmd_DCC_OnMessageCreate(DCC_Message: message);
#endif

#if defined OnDiscordCommandPerformed
    forward OnDiscordCommandPerformed(DCC_Message: message, DCC_User: author, bool: success);
#endif  

#endif

// POMOCNI KOD

#define dc%0command:%0(%1) DISCORD:%0(%1)

#define cmdparam DCC_Message:message,DCC_User:author,PARAMETRI[]
#define params PARAMETRI

// KOMANDICE

new
    DCC_Channel: gCommandChannel
;

public OnGameModeInit()
{
    printf("- Dawny Bot ucitan, verzija: 1.x");
    return 1;
}

dc command:verzija(cmdparam)
{
    static DCC_Channel:channel;
        
    DCC_GetMessageChannel(message, channel);
    return DCC_SendChannelMessage(channel, ":bot: Ja sam bot Dawny, verzija: 1.0");
}

public OnDiscordCommandPerformed(DCC_Message:message, DCC_User:author, bool:success)
{
    if (!success) 
    {
        static DCC_Channel:channel;
        
        DCC_GetMessageChannel(message, channel);
        return DCC_SendChannelMessage(channel, ":x: Ova komanda ne postoji.");
    }
    return 1;
} 