-- 光之剑路
local cm,m,o=GetID()
Duel.LoadScript("c60013052.lua")
cm.isChaosZeroNightmare=true	-- 有【灵光一闪】效果记述

local F_TH=m+10000000	-- 加入手卡时的回合数（只有加入手卡的回合能从手卡发动）

function cm.initial_effect(c)
	-- 卡名记述：「凶兆的使徒 罗丝薇瑟」（可用「剑穗」代替破坏 / 触发「凯尔肯的使徒」②）
	aux.AddCodeList(c,60013050)

	-- 记录这张卡加入手卡的回合
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_TO_HAND)
	e0:SetOperation(cm.thop)
	c:RegisterEffect(e0)

	-- 这张卡在加入手卡的回合也能从手卡发动
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(cm.handcon)
	c:RegisterEffect(e1)

	-- ①：作为通常陷阱发动
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,5))
	e2:SetCategory(CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)	-- 同一连锁1次
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(F_TH,RESET_EVENT+RESETS_STANDARD,0,1,Duel.GetTurnCount())
end
function cm.handcon(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(F_TH)>0 and c:GetFlagEffectLabel(F_TH)==Duel.GetTurnCount()
end

-- 可盖放的、有【灵光一闪】效果记述的魔法·陷阱（「光之剑路」以外）
function cm.setfil(c)
	return c.isChaosZeroNightmare and c:IsType(TYPE_QUICKPLAY+TYPE_TRAP)
		and not c:IsCode(m) and c:IsSSetable()
end
-- 「凶兆的使徒 罗丝薇瑟」（含同名异画）
function cm.rosefil(c)
	return c:IsCode(60013050,60013051) and c:IsAbleToHand()
end

-- ①的选项：
-- 1 原本（丢1手卡，从卡组·墓地盖放）
-- 2 灵光一闪I（不丢手卡，从卡组·墓地盖放）
-- 3 灵光一闪II（改为从卡组·墓地拿1只罗丝薇瑟加入手卡）
-- 4 灵光一闪III（原本 + 抽1）
-- 5 灵光一闪IV（从手卡把任意数量盖放，盖放回合可发动）
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local has=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
	local loc=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local b1=has and loc and Duel.IsExistingMatchingCard(cm.setfil,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil)
	local b2=loc and Duel.IsExistingMatchingCard(cm.setfil,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and Lingguang.canpay(c,tp)
	local b3=Duel.IsExistingMatchingCard(cm.rosefil,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and Lingguang.canpay(c,tp)
	local b4=has and loc and Duel.IsExistingMatchingCard(cm.setfil,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and Lingguang.canpay(c,tp)
	local b5=loc and Duel.IsExistingMatchingCard(cm.setfil,tp,LOCATION_HAND,0,1,nil) and Lingguang.canpay(c,tp)
	if chk==0 then return b1 or b2 or b3 or b4 or b5 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local has=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
	local loc=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local b1=has and loc and Duel.IsExistingMatchingCard(cm.setfil,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil)
	local b2=loc and Duel.IsExistingMatchingCard(cm.setfil,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and Lingguang.canpay(c,tp)
	local b3=Duel.IsExistingMatchingCard(cm.rosefil,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and Lingguang.canpay(c,tp)
	local b4=has and loc and Duel.IsExistingMatchingCard(cm.setfil,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and Lingguang.canpay(c,tp)
	local b5=loc and Duel.IsExistingMatchingCard(cm.setfil,tp,LOCATION_HAND,0,1,nil) and Lingguang.canpay(c,tp)
	if not b1 and not b2 and not b3 and not b4 and not b5 then return end
	local op=Lingguang.select(tp,{
		{b1,aux.Stringid(m,0),1},
		{b2,aux.Stringid(m,1),2},
		{b3,aux.Stringid(m,2),3},
		{b4,aux.Stringid(m,3),4},
		{b5,aux.Stringid(m,4),5}})
	-- 灵光一闪I~IV：破坏衍生物（或用「剑穗」代替）
	if op>=2 then
		if not Lingguang.lf(c,tp,e) then return end
	end
	-- 灵光一闪II：改为从卡组·墓地把1只罗丝薇瑟加入手卡（不丢弃手卡）
	if op==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.rosefil,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleDeck(tp)
		end
		return
	end
	-- 灵光一闪IV：从手卡把任意数量有【灵光一闪】记述的魔陷盖放，盖放的回合也能发动
	if op==5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,cm.setfil,tp,LOCATION_HAND,0,1,99,nil)
		cm.setop(e,tp,g,true)
		return
	end
	-- 原本 / 灵光一闪III：丢弃1张手卡（灵光一闪I 不需要）
	if op==1 or op==4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD,nil)==0 then return end
	end
	-- 从卡组·墓地选1张有【灵光一闪】记述的魔陷盖放
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setfil,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	cm.setop(e,tp,g,false)
	-- 灵光一闪III：那之后，自己抽1张
	if op==4 then Duel.Draw(tp,1,REASON_EFFECT) end
end
-- 盖放；seturn=true 时给速攻魔法/陷阱加「盖放的回合也能发动」
function cm.setop(e,tp,g,seturn)
	if g:GetCount()==0 then return end
	if Duel.SSet(tp,g)==0 then return end
	if not seturn then return end
	for tc in aux.Next(g) do
		local code=nil
		if tc:IsType(TYPE_QUICKPLAY) then
			code=EFFECT_QP_ACT_IN_SET_TURN
		elseif tc:IsType(TYPE_TRAP) then
			code=EFFECT_TRAP_ACT_IN_SET_TURN
		end
		if code then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(code)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
