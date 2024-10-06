--辉煌之双冰 菲约尔姆&尼弗尔
function c75099011.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_WATER),1)
	c:EnableReviveLimit()
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75099011,0))
	e1:SetCategory(CATEGORY_COUNTER+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,75099011)
	e1:SetLabel(1)
	e1:SetTarget(c75099011.cttg)
	e1:SetOperation(c75099011.ctop)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--frozen
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(c75099011.frozen)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_SET_ATTACK)
	e5:SetValue(0)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_SET_DEFENSE)
	e6:SetValue(0)
	c:RegisterEffect(e6)
	--counter
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(75099011,1))
	e7:SetCategory(CATEGORY_COUNTER+CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetHintTiming(TIMING_MAIN_END)
	e7:SetCountLimit(1,75099012)
	e7:SetLabel(2)
	e7:SetCondition(c75099011.ctcon)
	e7:SetTarget(c75099011.cttg)
	e7:SetOperation(c75099011.ctop)
	c:RegisterEffect(e7)
c75099011.frozen_list=true
end
function c75099011.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,nil,0x1750,1) end
end
function c75099011.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,nil,0x1750,1)
	for tc in aux.Next(g) do
		if tc:IsCanAddCounter(0x1750,1) and tc:AddCounter(0x1750,1) and tc:GetFlagEffect(75099001)==0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetCondition(c75099011.frcon)
			e1:SetValue(tc:GetAttack()*-1/4)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetValue(tc:GetDefense()*-1/4)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(75099001,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	end
	if e:GetLabel()==1 then
		local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e:GetHandler():RegisterEffect(e1)
	elseif e:GetLabel()==2 and Duel.GetFieldGroupCount(tp,LOCATION_FZONE,LOCATION_FZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(75099011,2)) then
		Duel.BreakEffect()
		local fg=Duel.GetFieldGroup(tp,LOCATION_FZONE,LOCATION_FZONE)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c75099011.frcon(e)
	return e:GetHandler():GetCounter(0x1750)>0
end
function c75099011.frozen(e,c)
	return c:GetCounter(0x1750)>=2
end
function c75099011.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
