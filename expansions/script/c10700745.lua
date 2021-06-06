--刹那芳华 夜巡月
function c10700745.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	c:EnableReviveLimit()  
	--use baseattack
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e0:SetCondition(c10700745.atkcon)
	e0:SetOperation(c10700745.atkop)
	c:RegisterEffect(e0) 
	--negate  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(10700745,0))  
	e1:SetCategory(CATEGORY_ATKCHANGE)  
	e1:SetType(EFFECT_TYPE_QUICK_O)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)  
	e1:SetCountLimit(1,10700745)
	e1:SetCost(c10700745.cost)
	e1:SetOperation(c10700745.operation)  
	c:RegisterEffect(e1)  
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2) 
	--spirit return
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(c10700745.retreg)
	c:RegisterEffect(e4) 
	--tohand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10700745,3))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e6:SetCondition(c10700745.thcon)
	e6:SetTarget(c10700745.thtg)
	e6:SetOperation(c10700745.thop)
	c:RegisterEffect(e6)
end
function c10700745.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c or Duel.GetAttackTarget()==c
end
function c10700745.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL) 
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(c:GetBaseAttack())
	c:RegisterEffect(e1)
end
function c10700745.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return c:IsAbleToRemoveAsCost() end  
	if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then  
		local fid = c:GetFieldID()
		c:RegisterFlagEffect(10700745,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
		e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)  
		e1:SetCountLimit(1)  
		e1:SetLabel(fid)  
		e1:SetLabelObject(c)  
		e1:SetCondition(c10700745.retcon3)
		e1:SetOperation(c10700745.retop3)  
		Duel.RegisterEffect(e1,tp)  
	end  
end  
function c10700745.retcon3(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetLabelObject()
	if c:GetFlagEffectLabel(10700745)==e:GetLabel() then return true
	else
		e:Reset()
		return false
	end
end 
function c10700745.retop3(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetLabelObject()
	Duel.Hint(HINT_CARD,0,10700745)
	Duel.ReturnToField(c)
	e:Reset()
end  
function c10700745.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	e1:SetValue(-1000)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e2,tp)
end
function c10700745.retreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(c10700745.retcon)
	e1:SetTarget(c10700745.rettg)
	e1:SetOperation(c10700745.retop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(c10700745.retcon2)
	e2:SetTarget(c10700745.rettg2)
	c:RegisterEffect(e2)
end
function c10700745.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) and not c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN) and not Duel.IsPlayerAffectedByEffect(tp,10700738)
end
function c10700745.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c10700745.thfilter(c)
	return c:IsSetCard(0x7cc) and c:IsAbleToHand()
end
function c10700745.retop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,10700738) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
		 local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10700745.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		 if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10700745,1)) then
			 Duel.BreakEffect()
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			 local sg=g:Select(tp,1,1,nil)
			 Duel.SendtoHand(sg,nil,REASON_EFFECT)
			 Duel.ConfirmCards(1-tp,sg)
		 end
	end
end
function c10700745.retcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) and c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN) and not Duel.IsPlayerAffectedByEffect(tp,10700738)
end
function c10700745.rettg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c10700745.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,10700738)
end
function c10700745.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() and e:GetHandler():GetFlagEffect(10700746)==0 end
	e:GetHandler():RegisterFlagEffect(10700746,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c10700745.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
		 local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10700745.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		 if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10700745,1)) then
			 Duel.BreakEffect()
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			 local sg=g:Select(tp,1,1,nil)
			 Duel.SendtoHand(sg,nil,REASON_EFFECT)
			 Duel.ConfirmCards(1-tp,sg)
		 end
	end
end