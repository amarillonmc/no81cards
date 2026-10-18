-- 刻刻帝·一之弹（Aleph）
local cm,m,o=GetID()

local F_KKKD=60013040+10000000	-- 「刻刻帝」②的适用次数（场地 6048 与陷阱 6043~6046 共用同一个计数器，锚在 6040 号段）
local F_KDRAW=60013040+20000000	-- 「每3次抽1张」已经抽过的次数（系列共用）

function cm.initial_effect(c)
	-- 卡名记述：「时崎狂三·时崎狂三」
	aux.AddCodeList(c,60013039)
	-- 作为通常魔法发动
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)

	-- 这张卡在加入手卡的对方回合也能从手卡发动
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(cm.handcon)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)

	-- ②：双方的回合结束阶段发动。墓地的这张卡回到卡组
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)	-- 结束阶段的效果必须限次，否则会在结束阶段反复诱发
	e3:SetRange(LOCATION_GRAVE)
	e3:SetOperation(cm.gyop)
	c:RegisterEffect(e3)
end

-- 手卡发动的condition：对方回合，且这张卡是这个回合加入手卡的
function cm.handcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and (c:GetTurnID()==Duel.GetTurnCount() or Duel.GetTurnCount()==1)
end
-- 「时崎狂三·时崎狂三」
function cm.affil(c)
	return c:IsCode(60013039)
end
function cm.spfilter(c,e,tp)
	return cm.affil(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.thfilter(c)
	return cm.affil(c) and c:IsAbleToHand()
end
function cm.tdfilter(c)
	return cm.affil(c) and c:IsAbleToDeck()
end
-- 选1项（只列出能适用的项）
function cm.selectop(tp,b1,b2,b3)
	local t={}
	if b1 then table.insert(t,1) end
	if b2 then table.insert(t,2) end
	if b3 then table.insert(t,3) end
	if #t==0 then return 0 end
	if #t==1 then return t[1] end
	local s={}
	for i=1,#t do s[i]=aux.Stringid(m,t[i]-1) end
	return t[Duel.SelectOption(tp,table.unpack(s))+1]
end
-- 手卡发动处理完后，这张卡从手卡送去墓地（按魔法的用法）
function cm.togy(c)
	if c:IsLocation(LOCATION_HAND) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
			or Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_MZONE,0,1,nil)
			or Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_MZONE,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_HAND,0,1,nil)
	local op=cm.selectop(tp,b1,b2,b3)
	if op==1 then
		-- ●选自己手卡1只「时崎狂三·时崎狂三」特殊召唤
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif op==2 then
		-- ●选自己场上1只「时崎狂三·时崎狂三」回到手卡，那之后可以抽1张
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			if Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	elseif op==3 then
		-- ●选自己手卡1只「时崎狂三·时崎狂三」回到卡组，那之后可以抽2张
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_HAND,0,1,1,nil)
		if #g>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
			if Duel.IsPlayerCanDraw(tp,2) and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
				Duel.Draw(tp,2,REASON_EFFECT)
			end
		end
	end
	cm.togy(c)
end
-- ②：墓地的这张卡回到卡组；自己每3次把「刻刻帝」的②的效果适用，可以抽1张
function cm.gyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_GRAVE) then return end
	if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
	-- 「刻刻帝」②的适用次数：全系列（子弹·场地·陷阱）共用同一个计数器
	local ap=Duel.GetFlagEffect(tp,F_KKKD)+1
	Duel.RegisterFlagEffect(tp,F_KKKD,0,0,1)
	-- 每满3次可以抽1张（已抽过的次数用 F_KDRAW 记录，避免重复抽）
	local dr=Duel.GetFlagEffect(tp,F_KDRAW)
	if ap-dr*3>=3 and Duel.IsPlayerCanDraw(tp,1) then
		if Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
			Duel.RegisterFlagEffect(tp,F_KDRAW,0,0,1)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
