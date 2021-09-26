--魔界侯爵 阿蒙·深渊
local m=40010044
local cm=_G["c"..m]
cm.named_with_Amon=1
function cm.Amon(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Amon
end
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)  
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)  
	--summon with s/t
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetTarget(function(e,c) return e:GetHandler()~=c and c:IsLocation(LOCATION_PZONE) and c:IsType(TYPE_PENDULUM) end)
	e1:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e1)  
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.sumcon)
	e2:SetTarget(cm.sumtg)
	e2:SetOperation(cm.sumop)
	c:RegisterEffect(e2)  
	--apply the effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.effcon)
	e3:SetTarget(cm.efftg)
	e3:SetOperation(cm.effop)
	c:RegisterEffect(e3)  
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local pos=0
	if c:IsSummonable(true,nil,1) then pos=pos+POS_FACEUP_ATTACK end
	if c:IsMSetable(true,nil,1) then pos=pos+POS_FACEDOWN_DEFENSE end
	if pos==0 then return end
	if Duel.SelectPosition(tp,c,pos)==POS_FACEUP_ATTACK then
		Duel.Summon(tp,c,true,nil,1)
	else
		Duel.MSet(tp,c,true,nil,1)
	end
end
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.tefilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function cm.thfilter(c)
	return cm.Amon(c) and c:IsFaceup() and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local chk1=c:GetMaterial():FilterCount(Card.IsType,nil,TYPE_PENDULUM)>0
	local chk2=c:GetMaterial():FilterCount(Card.IsCode,nil,40009828)>0
	local chk3=c:GetMaterial():FilterCount(Card.IsCode,nil,40009836)>0
	if chk==0 then return (chk1 and Duel.IsExistingMatchingCard(cm.tefilter,tp,LOCATION_DECK,0,1,nil))
		or (chk2 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_EXTRA,0,1,nil)) end
	e:SetCategory(0)
	if chk1 then
		e:SetCategory(e:GetCategory()|(CATEGORY_TOEXTRA))
		Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
	end
	if chk2 then
		e:SetCategory(e:GetCategory()|(CATEGORY_TOHAND))
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
		Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,0,0,0)
	end
	if chk3 then
		e:SetCategory(e:GetCategory()|(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE))
	end
end
function cm.sumfilter(c)
	return c:IsSummonable(true,nil,1) 
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chk1=c:GetMaterial():FilterCount(Card.IsType,nil,TYPE_PENDULUM)>0 and Duel.GetFlagEffect(tp,m)==0
	local chk2=c:GetMaterial():FilterCount(Card.IsCode,nil,40009828)>0
	local chk3=c:GetMaterial():FilterCount(Card.IsCode,nil,40009836)>0
	if chk1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		local g1=Duel.SelectMatchingCard(tp,cm.tefilter,tp,LOCATION_DECK,0,1,1,nil)
		if g1:GetCount()>0 then
			Duel.SendtoExtraP(g1,tp,REASON_EFFECT)
			Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		end
	end
	if chk2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		if g2:GetCount()>0 then
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
			if Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
				Duel.BreakEffect()
				Duel.ShuffleHand(tp)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
				local sg2=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
				if sg2:GetCount()>0 then
					Duel.Summon(tp,sg2:GetFirst(),true,nil)
				end
			end
		end
	end
	if chk3 then
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(600)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e2)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_IMMUNE_EFFECT)
			e4:SetValue(cm.efilter)
			e4:SetOwnerPlayer(tp)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e4)
		end
	end
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end