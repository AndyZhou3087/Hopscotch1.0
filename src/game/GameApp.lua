
require("launcher.config")
require("cocos.init")
require("framework.init")

require("game.events.EventNames")

require("game.config.GameConfig")
require("game.config.RoomsBgConfig")
require("game.config.RoomGoodsConfig")
require("game.config.OrnamentsConfig")
require("game.config.CoinsConfig")
require("game.config.MapGroupConfigD")
require("game.config.MapGroupConfigC")
require("game.config.MapGroupConfigB")
require("game.config.MapGroupConfigA")
require("game.config.MapGroupConfigS")
require("game.config.MapRunningConfig")
require("game.config.MapFirstGroup")
require("game.config.MapTwoLeanConfig")
require("game.config.PaymentConfig")
require("game.config.RoleConfig")
require("game.config.GoodsConfig")
require("game.config.GiftConfig")
require("game.config.SceneConfig")
require("game.config.DiamondConfig")

PoolManager = require("game.tools.PoolManager")
TimeUtil = require("game.tools.TimeUtil")
GameController = require("game.controller.GameController")
GameDataManager = require("game.data.GameDataManager")
AudioManager = require("game.tools.AudioManager")
LoadResManager = require("game.tools.LoadResManager")
Tools = require("game.tools.Tools")
DataPersistence = require("game.tools.DataPersistence")
SDKUtil = require("game.tools.SDKUtil")

local Alert = require("game.view.dialog.Dialog")

--自定义事件管理类
require("game.events.GameDispatcher"):getInstance()
require("game.controller.UIController").new()

local GameScene = require("game.scenes.GameScene")

local GameApp = class("GameApp", cc.mvc.AppBase)    --继承AppBase：app = self

function GameApp:ctor()
    GameApp.super.ctor(self,"GameApp","game")    --替换app目录
    
    DataPersistence.insertAttribute("user_diamond",InitDiamond)  --钻石
    DataPersistence.insertAttribute("bestscore",0)    --最佳分数

    --音乐、音效
    DataPersistence.insertAttribute("music",true)
    DataPersistence.insertAttribute("sound",true)

    DataPersistence.insertAttribute("cur_roleID",1)      --当前使用角色id
    DataPersistence.insertAttribute("modle_list",{ModleVo={roleId =1,isOwn = true},})    --已经解锁的角色模型列表，元素为ModleVo
    
    DataPersistence.insertAttribute("cur_sceneID",1)      --当前使用场景
    DataPersistence.insertAttribute("scene_list",{SceneVo={sceneId =1,isOwn = true},})    --已经解锁的场景列表，元素为SceneVo

    --物品相关
    DataPersistence.insertAttribute("goods_list",{})    --拥有物品列表，列表元素为GoodsVo
    --需要缓存的使用道具记录,{当前使用的道具id列表}
    DataPersistence.insertAttribute("cacheGoods",{})

    --复活倒计时
    DataPersistence.insertAttribute("revive_endTime",0) --倒计时回满结束时间戳
    --复活剩余时间
    DataPersistence.insertAttribute("remain_reviveTime",0) --倒计时回满结束时间戳
    --复活次数
    DataPersistence.insertAttribute("reviveCount",0)
    
    --开局倒计时
    DataPersistence.insertAttribute("start_endTime",0) --倒计时回满结束时间戳
    --开局剩余时间
    DataPersistence.insertAttribute("remain_startTime",0) --倒计时回满结束时间戳
    --开局次数
    DataPersistence.insertAttribute("startCount",0)
    
    --免费礼物倒计时
    DataPersistence.insertAttribute("free_endTime",0) --倒计时回满结束时间戳
    --免费礼物剩余时间
    DataPersistence.insertAttribute("remain_freeTime",0) --倒计时回满结束时间戳

    --角色礼包每日领奖
--    DataPersistence.insertAttribute("rolegift",{})

    --vip礼包每日领奖
--    DataPersistence.insertAttribute("vipgift",{})
end

function GameApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    if DataPersistence.init() then
        self:enterScene("LoginScene")
    end
end

function GameApp:enterLoadScene()
    cc.FileUtils:getInstance():addSearchPath("res/")
    self:enterScene("LoadScene")
end

function GameApp:enterMainScene(parameters)
    cc.FileUtils:getInstance():addSearchPath("res/")
    self:enterScene("MainScene")
end

function GameApp:enterGameScene(parameters)
    cc.Director:getInstance():purgeCachedData()
    Tools.delayCallFunc(0.01,function()
        self.m_fightScene = GameScene.new(handler(self,self.checkEnterFight))
        --物理场景太二了，不加retain会立马给我清除了
        self.m_fightScene:retain()
    end)
end

--进入战斗场景
function GameApp:checkEnterFight(parameters)
    if not tolua.isnull(self.m_fightScene) then
        display.replaceScene(self.m_fightScene)
    end
end

--[[弹窗
--@param:
{
type:弹框类型
content:弹框内容
title:弹框标题
okStr:确认按钮文字
cancleStr:取消按钮文字
okFunc:确认回调
cancleFunc:取消回调
isClose:点击确认后就关闭毕弹窗
}
--]]
function GameApp:alert(_params)
    local runScene = display.getRunningScene()
    if not tolua.isnull(self.m_alert) and self.m_alert:getParent()~=runScene then
        self.m_alert:toClose(true)
        self.m_alert = nil
    end
    if tolua.isnull(self.m_alert) then
        self.m_alert = Alert.new(_params.type,_params.okStr,_params.cancleStr,_params.isClose,_params.pType)
        self.m_alert:show(UI_ZORDER.ALERT_ZORDER)
    end
    if _params.title then
        self.m_alert:setTitle(_params.title)
    end
    if _params.content then
        self.m_alert:setContent(_params.content)
    end
    if _params.okFunc then
        self.m_alert:setOkFunc(_params.okFunc)
    end
    if _params.cancleFunc then
        self.m_alert:setCancleFunc(_params.cancleFunc)
    end
    return self.m_alert
end

function GameApp:onEnterBackground()
    print("chjh 进入后台")
--    GameDispatcher:dispatch(EventNames.EVENT_BACKGROUND)
    GameController.setCollsionEnable(false)
    GameDataManager.saveGameData()
end

function GameApp:onEnterForeground()
    print("chjh 进入前台")
    if GameController.isInPause() then
        GameController.pauseGame()
    else
        TimeUtil.init()
    end
    GameController.setCollsionEnable(true)

    --音乐处理
    if GameDataManager.isMusicOpen()==false then
        AudioManager.stop(1)
    end

    if GameDataManager.isSoundOpen()==false then
        AudioManager.stop(2)
    end
end

return GameApp
