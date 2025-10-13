--虹龍圣域
function c11185255.initial_effect(c)
	c:EnableCounterPermit(0x452)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11185255,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,11185255)
	e1:SetTarget(c11185255.thtg)
	e1:SetOperation(c11185255.thop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c11185255.rmtarget)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,11185255+1)
	e3:SetTarget(c11185255.destg)
	e3:SetValue(c11185255.value)
	e3:SetOperation(c11185255.desop)
	c:RegisterEffect(e3)
end
function c11185255.rmfilter(c)
	return c:IsSetCard(0x453) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c11185255.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11185255.rmfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c11185255.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c11185255.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.Remove(g,0x5,REASON_EFFECT)>0 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(11185255,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local sg=g:Select(tp,1,1,nil)
			if #sg>0 then
				Duel.BreakEffect()
				Duel.HintSelection(sg)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
			end
		end
	end
end
function c11185255.rmtarget(e,c)
	return c:IsSetCard(0x453)
end
function c11185255.dfilter(c,tp)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup() and c:IsSetCard(0x453) and c:IsControler(tp)
		and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c11185255.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local count=eg:FilterCount(c11185255.dfilter,nil,tp)
		return count>0 and Duel.IsCanRemoveCounter(tp,1,0,0x452,2,REASON_COST)
	end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c11185255.value(e,c)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup() and c:IsSetCard(0x453)
		and c:IsControler(e:GetHandlerPlayer())
end
function c11185255.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveCounter(tp,1,0,0x452,2,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetOperation(c11185255.op)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
end
function c11185255.op(e)
	Duel.Hint(HINT_CARD,0,11185255)
	local tp=e:GetHandlerPlayer()
	if Duel.SelectYesNo(tp,aux.Stringid(11185255,1)) then e:GetHandler():AddCounter(0x452,1) end
end