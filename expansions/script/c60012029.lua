-- 懒惰的波摇花
--Duel.LoadScript("c.lua")
-- 懒惰的波摇花
local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 添加波摇花系列的卡名记述，方便其他卡识别
	aux.AddCodeList(c,60012027)
	
	-- 可以从手卡发动的效果：3个以上进化指示物的场合
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(cm.handcon)
	c:RegisterEffect(e0)
	
	-- 陷阱的激活效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end

-- 手卡发动的条件：3个以上进化指示物，用你给的判断条件
function cm.handcon(e)
	return Duel.IsCanRemoveCounter(e:GetHandlerPlayer(),1,0,0x624,3,REASON_RULE)
end

-- 目标函数
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,0,1,nil) end
	-- 选择对方场上最多2张卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end

-- 效果执行
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	-- 丢弃1张手卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local dc=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if not dc then return end
	Duel.SendtoGrave(dc,REASON_DISCARD+REASON_EFFECT)
	-- 破坏选中的卡
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	-- 如果丢弃的是7星以上的怪兽，就抽破坏数量的卡
	if dc:IsType(TYPE_MONSTER) and dc:IsLevelAbove(7) and ct>0 then
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
