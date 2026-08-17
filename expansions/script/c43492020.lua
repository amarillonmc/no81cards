-- 凄陌寒昼·臻冰之剑
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,43492025)
	--①效果：仪式召唤成功时攻击力上升
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.atkcon)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
	--②效果：对方每次发动效果，给对方场上表侧怪兽放置霜冻指示物
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.regcon)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
end

--①效果条件
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(s.atkfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
    if chk==0 then return ct>0 end
end
--①效果操作
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(s.atkfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if ct>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function s.atkfilter(c)
	return c:IsSetCard(0x3f15) and c:IsFaceupEx()
end

--②效果条件：对方发动卡的效果
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActivated()
end

--②效果操作：给对方场上所有表侧怪兽放置1个霜冻指示物，并注册相关负面效果
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		tc:AddCounter(0x1f15,1)
		-- 如果该怪兽已注册过效果，则跳过，避免重复
		if tc:GetFlagEffect(id)==0 then
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
			--1个以上：攻击力守备力变成0，不能攻击
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetCondition(s.ctcon1)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			tc:RegisterEffect(e2)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CANNOT_ATTACK)
			e3:SetValue(1)
			tc:RegisterEffect(e3)
			--2个以上：不能作为素材，不能解放
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e4:SetRange(LOCATION_MZONE)
			e4:SetCode(EFFECT_UNRELEASABLE_SUM)
			e4:SetValue(1)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			e4:SetCondition(s.ctcon2)
			tc:RegisterEffect(e4)
			local e5=e4:Clone()
			e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			tc:RegisterEffect(e5)
			local e6=e4:Clone()
			e6:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			e6:SetValue(s.fuslimit)
			tc:RegisterEffect(e6)
			local e7=e4:Clone()
			e7:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			tc:RegisterEffect(e7)
			local e8=e4:Clone()
			e8:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			tc:RegisterEffect(e8)
			local e9=e4:Clone()
			e9:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			tc:RegisterEffect(e9)
			--3个以上：效果无效
			local e10=Effect.CreateEffect(c)
			e10:SetType(EFFECT_TYPE_SINGLE)
			e10:SetCode(EFFECT_DISABLE)
			e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e10:SetReset(RESET_EVENT+RESETS_STANDARD)
			e10:SetCondition(s.ctcon3)
			tc:RegisterEffect(e10)
			local e11=e10:Clone()
			e11:SetCode(EFFECT_DISABLE_EFFECT)
			e11:SetValue(1)
			tc:RegisterEffect(e11)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e12=e10:Clone()
				e12:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				tc:RegisterEffect(e12)
			end
			local e13=Effect.CreateEffect(c)
			e13:SetType(EFFECT_TYPE_FIELD)
			e13:SetCode(EFFECT_ACTIVATE_COST)
			e13:SetRange(LOCATION_MZONE)
			e13:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e13:SetTargetRange(1,0)
			e13:SetCondition(s.ctcon4)
			e13:SetCost(s.costchk)
			e13:SetOperation(s.costop)
			tc:RegisterEffect(e13)
			local e14=Effect.CreateEffect(c)
			e14:SetType(EFFECT_TYPE_FIELD)
			e14:SetCode(EFFECT_FLAG_EFFECT+43492020)
			e14:SetRange(LOCATION_MZONE)
			e14:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e14:SetCondition(s.ctcon4)
			e14:SetTargetRange(1,0)
			tc:RegisterEffect(e14)
		end
	end
end

function s.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function s.ctcon1(e)
	return e:GetHandler():GetCounter(0x1f15)>=1
end
function s.ctcon2(e)
	return e:GetHandler():GetCounter(0x1f15)>=2
end
function s.ctcon3(e)
	return e:GetHandler():GetCounter(0x1f15)>=3
end
function s.ctcon4(e)
	return e:GetHandler():GetCounter(0x1f15)>=4
end

--支付检查
function s.costchk(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local ct=Duel.GetCounter(tp,LOCATION_MZONE,0,0x1f15)*Duel.GetFlagEffect(tp,43492020)
	return Duel.CheckLPCost(tp,ct*100)
end

--支付操作
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local ct=Duel.GetCounter(tp,LOCATION_MZONE,0,0x1f15)
	Duel.PayLPCost(tp,ct*100)
end