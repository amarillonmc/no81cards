-- 时之精灵·刻刻帝
local cm,m,o=GetID()

local F_KKKD=60013040+10000000	-- 「刻刻帝」②的适用次数（场地与陷阱共用同一个计数器，锚在 6040 号段）
local F_KDRAW=60013040+20000000	-- 「每3次抽1张」已经抽过的次数（系列共用）

function cm.initial_effect(c)
	-- 作为场地魔法发动
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)

	-- ②：双方的回合结束阶段发动。墓地的这张卡回到卡组
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)	-- 结束阶段的效果必须限次，否则会在结束阶段反复诱发
	e2:SetRange(LOCATION_GRAVE)
	e2:SetOperation(cm.gyop)
	c:RegisterEffect(e2)
end

-- 「灼红之矢」
function cm.tffilter(c)
	return c:IsCode(60013049)
end
-- ①：作为发动时的效果处理，可以从卡组·墓地把「灼红之矢」表侧表示放置
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if not Duel.IsExistingMatchingCard(cm.tffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.tffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	local fd=tc:IsLocation(LOCATION_DECK)
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	if fd then Duel.ShuffleDeck(tp) end
end
-- ②：墓地的这张卡回到卡组；自己每3次把「刻刻帝」通常陷阱卡的②的效果适用，可以抽1张
function cm.gyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_GRAVE) then return end
	if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
	-- 「刻刻帝」②的适用次数：场地与陷阱共用同一个计数器
	local ap=Duel.GetFlagEffect(tp,F_KKKD)+1
	Duel.RegisterFlagEffect(tp,F_KKKD,0,0,1)
	-- 每满3次可以抽1张（已抽过的次数用 F_KDRAW 记录，避免重复抽）
	local dr=Duel.GetFlagEffect(tp,F_KDRAW)
	if ap-dr*3>=3 and Duel.IsPlayerCanDraw(tp,1) then
		if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.RegisterFlagEffect(tp,F_KDRAW,0,0,1)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
