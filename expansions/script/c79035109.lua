--不畏苦暗·临光
function c79035109.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xca3),1)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)	
	--atk def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c79035109.adcon)
	e1:SetValue(800)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,79035109)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCost(c79035109.spcost)
	e3:SetTarget(c79035109.sptg)
	e3:SetOperation(c79035109.spop)
	c:RegisterEffect(e3)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79035109,0))
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_POSITION)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c79035109.discon)
	e3:SetTarget(c79035109.distg)
	e3:SetOperation(c79035109.disop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c79035109.desreptg)
	e4:SetValue(c79035109.desrepval)
	e4:SetOperation(c79035109.desrepop)
	c:RegisterEffect(e4)
	--p set
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c79035109.pscon)
	e5:SetTarget(c79035109.pstg)
	e5:SetOperation(c79035109.psop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_DESTROY)
	c:RegisterEffect(e6)
end
function c79035109.adcon(e,c)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0xca3)
end
function c79035109.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
end
function c79035109.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function c79035109.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount()<=0 then return end
	Duel.SpecialSummon(c,SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF,tp,tp,false,false,POS_FACEUP)
end
function c79035109.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainDisablable(ev) and (e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) or e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF))
end
function c79035109.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c79035109.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) then
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(79035109,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(79035109,0))
	end
end
function c79035109.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c79035109.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c79035109.repfilter,1,nil,tp)
		and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c79035109.desrepval(e,c)
	return c79035109.repfilter(c,e:GetHandlerPlayer())
end
function c79035109.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_DISCARD)
	if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c79035109.retop)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.Hint(HINT_CARD,0,79035109)
end
function c79035109.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,79035109)
	Duel.ReturnToField(e:GetLabelObject())
end
function c79035109.pscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ((c:IsReason(REASON_EFFECT) and rp==1-tp) or c:IsReason(REASON_BATTLE)) and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_ONFIELD) 
end
function c79035109.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c79035109.psop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end




