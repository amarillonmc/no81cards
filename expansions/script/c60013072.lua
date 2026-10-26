-- 创造与破坏
local cm,m,o=GetID()
Duel.LoadScript("c60013052.lua")
cm.isChaosZeroNightmare=true	-- 有【灵光一闪】效果记述

function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_RECOVER+CATEGORY_DAMAGE+CATEGORY_ATKCHANGE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e0:SetTarget(cm.tg)
	e0:SetOperation(cm.op)
	c:RegisterEffect(e0)
end

-- 有【灵光一闪】效果记述的怪兽
function cm.lgmonster(c)
	return c.isChaosZeroNightmare and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end

function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=true
	local b2=Lingguang.canlf(tp)
	local b3=Lingguang.canlf(tp)
	local b4=Lingguang.canlf(tp)
	local b5=Lingguang.canlf(tp)
	if chk==0 then return b1 or b2 or b3 or b4 or b5 end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=true
	local b2=Lingguang.canlf(tp)
	local b3=Lingguang.canlf(tp)
	local b4=Lingguang.canlf(tp)
	local b5=Lingguang.canlf(tp)
	if not b1 and not b2 and not b3 and not b4 and not b5 then return end
	local op=Lingguang.select(tp,{
		{b1,aux.Stringid(m,0),1},
		{b2,aux.Stringid(m,1),2},
		{b3,aux.Stringid(m,2),3},
		{b4,aux.Stringid(m,3),4},
		{b5,aux.Stringid(m,4),5}})
	-- 灵光一闪I~IV：破坏衍生物
	if op>=2 then
		if not Lingguang.lf(c,tp,e) then return end
	end
	-- 回复/伤害（灵光一闪I 为3倍）
	local rec=500
	local dmg=300
	if op==2 then rec=1500 dmg=900 end
	Duel.Recover(tp,rec,REASON_EFFECT)
	Duel.Damage(1-tp,dmg,REASON_EFFECT)
	-- 后续：自己没有手卡时适用（灵光一闪III 有手卡也能适用）
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and op~=4 then return end
	-- 攻守上升数值（灵光一闪II 为3倍）
	local boost=1000
	if op==3 then boost=3000 end
	-- 第二个黑点需要自己有盖放的卡才能选
	local can2=Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_SZONE,0,1,nil)
	local do1=false
	local do2=false
	if op==5 then
		-- 灵光一闪IV：两项各适用（第二项需要盖放的卡）
		do1=true
		do2=can2
	else
		if can2 then
			local op2=Duel.SelectOption(tp,aux.Stringid(m,5),aux.Stringid(m,6))
			if op2==0 then do1=true else do2=true end
		else
			-- 没有盖放的卡时只有第一个黑点可用
			do1=true
		end
	end
	if do1 then
		-- ●自己场上有【灵光一闪】记述的怪兽攻守上升，不会成为对方效果的对象
		local g=Duel.GetMatchingGroup(cm.lgmonster,tp,LOCATION_MZONE,0,nil)
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(boost)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e3:SetValue(aux.tgoval)
			tc:RegisterEffect(e3)
		end
	end
	if do2 then
		-- ●自己魔陷区盖放的卡给对方确认，其中的速攻魔法在盖放的回合也能发动
		local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_SZONE,0,nil)
		if g:GetCount()>0 then
			Duel.ConfirmCards(1-tp,g)
			for tc in aux.Next(g) do
				if tc:IsType(TYPE_QUICKPLAY) then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
			end
		end
	end
end
