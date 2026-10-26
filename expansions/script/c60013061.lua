-- 循环之刃
local cm,m,o=GetID()
Duel.LoadScript("c60013052.lua")
cm.isChaosZeroNightmare=true	-- 有【灵光一闪】效果记述

local COUNTER_SPELL=0x1	-- 魔力指示物
local F_MING=60013057+30000000	-- 「片鳞·明」①的伤害累积（与 60013057 共用）
local F_AN=60013058+30000000	-- 「片鳞·暗」①的回复累积（与 60013058 共用）

function cm.initial_effect(c)
	-- 卡名记述：「凶兆的使徒 罗丝薇瑟」（可用「剑穗」代替破坏 / 触发「凯尔肯的使徒」②）
	aux.AddCodeList(c,60013050)

	-- 可以放置魔力指示物
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_COUNTER_PERMIT+COUNTER_SPELL)
	e1:SetValue(0xff)
	c:RegisterEffect(e1)

	-- 作为永续魔法发动：放置4个魔力指示物（灵光一闪I：6个）
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,6))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)	-- 同一连锁1次
	e0:SetOperation(cm.actop)
	c:RegisterEffect(e0)

	-- ②：取除1个魔力指示物，丢1手卡，回复300并给与300伤害
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_DAMAGE+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)	-- 同一连锁上最多1次
	e2:SetCost(cm.cost2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end

-- ①：放置指示物
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=true
	local b2=Lingguang.canpay(c,tp)
	local op=Lingguang.select(tp,{
		{b1,aux.Stringid(m,0),1},
		{b2,aux.Stringid(m,1),2}})
	local num=4
	if op==2 and Lingguang.lf(c,tp,e) then num=6 end
	c:AddCounter(COUNTER_SPELL,num)
end

-- ②的cost：取除1个魔力指示物
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,COUNTER_SPELL,1,REASON_COST) end
	c:RemoveCounter(tp,COUNTER_SPELL,1,REASON_COST)
end

function cm.suifil(c)
	return c:IsCode(60013053) and c:IsAbleToHand()
end
-- ②的target：至少有1个能选的选项
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 or Lingguang.canpay(e:GetHandler(),tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,300)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
end
-- ②
function cm.op2main(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local has=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
	local b1=has
	local b2=Lingguang.canpay(c,tp)
	local b3=has and Duel.IsExistingMatchingCard(cm.suifil,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil) and Lingguang.canpay(c,tp)
	local b4=has and Duel.IsExistingMatchingCard(Lingguang.rosefilter,tp,LOCATION_MZONE,0,1,nil) and Lingguang.canpay(c,tp)
	if not b1 and not b2 and not b3 and not b4 then return end
	local op=Lingguang.select(tp,{
		{b1,aux.Stringid(m,2),1},
		{b2,aux.Stringid(m,3),2},
		{b3,aux.Stringid(m,4),3},
		{b4,aux.Stringid(m,5),4}})
	-- 灵光一闪II~IV：破坏衍生物（或把「剑穗」送去墓地代替）
	if op>=2 then
		if not Lingguang.lf(c,tp,e) then return end
	end
	-- 丢弃1张手卡（灵光一闪II 不需要）
	if op==1 or op==3 or op==4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD,nil)==0 then return end
	end
	-- 这次的伤害/回复：基础300，再加上「片鳞·明」「片鳞·暗」①累积的加成
	local dmg=300+200*Duel.GetFlagEffect(tp,F_MING)
	local rec=300+400*Duel.GetFlagEffect(tp,F_AN)
	Duel.Recover(tp,rec,REASON_EFFECT)
	Duel.Damage(1-tp,dmg,REASON_EFFECT)
	if op==3 then
		-- 灵光一闪III：从卡组·墓地拿2张「剑穗」
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.suifil,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,2,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleDeck(tp)
		end
	elseif op==4 then
		-- 灵光一闪IV：自己场上1只罗丝薇瑟攻击力·守备力+1000，不会被效果破坏
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local g=Duel.SelectMatchingCard(tp,Lingguang.rosefilter,tp,LOCATION_MZONE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e3:SetValue(1)
			tc:RegisterEffect(e3)
		end
	end
end

-- ②的收尾：所有灵光处理完之后，这张卡没有魔力指示物的场合破坏
-- 这一段独立于灵光一闪的分支，任何强化都不会跳过它
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	cm.op2main(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:GetCounter(COUNTER_SPELL)==0 then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
