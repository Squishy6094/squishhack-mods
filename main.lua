-- name: SquishHack Mods


TitlecardStages = {
    [LEVEL_BOWSER_1] = {
        name = "Bowser Fight 1",
    },
    [LEVEL_BOWSER_2] = {
        name = "Bowser Fight 2"
    },
    [LEVEL_BOWSER_3] = {
        name = "Bowser Fight 3"
    },
    [LEVEL_BITDW] = {
    },
    [LEVEL_BITFS] = {
    },
    [LEVEL_BITS] = {
    },
}

local levelCardTimerMax = 150
local levelCardTimer = 0

local bannerTop = false
local bannerBottom = false

local bannerOffsetMax = 50
local bannerTopOffset = 0
local bannerBottomOffset = 0
local bannerColor = {r = 0, g = 0, b = 0}
local function hud_render()
    djui_hud_set_resolution(RESOLUTION_DJUI)
    local djuiWidth = djui_hud_get_screen_width()
    local djuiHeight = djui_hud_get_screen_height()
    djui_hud_set_resolution(RESOLUTION_N64)
    local screenWidth = djuiWidth * 240/djuiHeight
    local screenHeight = 240

    bannerTop = false
    bannerBottom = false

    if levelCardTimer > 0 then
        levelCardTimer = levelCardTimer - 1
        bannerTop = true
        bannerBottom = true
    end

    local cardInfo = TitlecardStages[gNetworkPlayers[0].currLevelNum]
    levelName = (cardInfo and cardInfo.name) and cardInfo.name or get_level_name(gNetworkPlayers[0].currCourseNum, gNetworkPlayers[0].currLevelNum, gNetworkPlayers[0].currAreaIndex)
    subTitle = (cardInfo and cardInfo.subTitle) and cardInfo.subTitle or get_star_name(gNetworkPlayers[0].currCourseNum, gNetworkPlayers[0].currActNum) or ""

    -- Render Top/Bottom Banners
    djui_hud_set_font(FONT_RECOLOR_HUD)
    bannerTopOffset = math.lerp(bannerTopOffset, bannerTop and 0 or bannerOffsetMax, 0.1)
    if bannerTop or bannerTopOffset < bannerOffsetMax then
        djui_hud_set_color(bannerColor.r, bannerColor.g, bannerColor.b, 200)
        djui_hud_render_rect(0, -bannerTopOffset, screenWidth, 32)
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_print_text(levelName, screenWidth*0.5 - djui_hud_measure_text(levelName)*0.5, 8 - bannerTopOffset, 1)
    end
    bannerBottomOffset = math.lerp(bannerBottomOffset, bannerBottom and 0 or bannerOffsetMax, 0.1)
    if bannerBottom or bannerBottomOffset < bannerOffsetMax then
        djui_hud_set_color(bannerColor.r, bannerColor.g, bannerColor.b, 200)
        djui_hud_render_rect(0, screenHeight - 32 + bannerTopOffset, screenWidth, 32)
        djui_hud_set_color(255, 255, 255, 255)
        djui_hud_print_text(subTitle, screenWidth*0.5 - djui_hud_measure_text(subTitle)*0.5, screenHeight - 24 + bannerTopOffset, 1)
    end

end

local function hud_render_behind()
    hud_hide()
end

local function level_init()
    levelCardTimer = levelCardTimerMax
end

hook_event(HOOK_ON_HUD_RENDER, hud_render)
hook_event(HOOK_ON_HUD_RENDER_BEHIND, hud_render_behind)
hook_event(HOOK_ON_LEVEL_INIT, level_init)
