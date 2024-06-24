--孤高孤傲
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+id)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
	aux.RegisterMergedDelayedEvent(c,id,EVENT_REMOVE)
end
function s.tgfilter(c,race)
	return c:IsRace(race) and c:IsAbleToGrave()
end
function s.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e) and c:IsLocation(LOCATION_REMOVED) and c:IsPreviousLocation(LOCATION_DECK)
		and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil,c:GetRace())
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and chkc:IsControler(tp) end
	if chk==0 then return eg:IsExists(s.cfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=eg:FilterSelect(tp,s.cfilter,1,1,nil,e)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetRace())
		local gc=g:GetFirst()
		if gc and Duel.SendtoGrave(gc,REASON_EFFECT)~=0 and gc:IsLocation(LOCATION_GRAVE) then
			Debug.Message(1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_SPSUMMON_SUCCESS)
			e1:SetRange(LOCATION_GRAVE)
			e1:SetLabelObject(tc)
			e1:SetCondition(s.rmcon)
			e1:SetOperation(s.rmop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			gc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EVENT_SUMMON_SUCCESS)
			gc:RegisterEffect(e2)
			local e3=e1:Clone()
			e3:SetCode(EVENT_TO_DECK)
			gc:RegisterEffect(e3)
			local e4=e1:Clone()
			e4:SetCode(EVENT_TO_HAND)
			gc:RegisterEffect(e4)
			local e5=e1:Clone()
			e5:SetCode(EVENT_TO_GRAVE)
			gc:RegisterEffect(e5)
			local e6=e1:Clone()
			e6:SetCode(EVENT_SSET)
			gc:RegisterEffect(e6)
			local e7=e1:Clone()
			e7:SetCode(EVENT_LEAVE_FIELD)
			gc:RegisterEffect(e7)
			Debug.Message(2)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetLabelObject(c)
	e1:SetCondition(s.tgcon2)
	e1:SetOperation(s.tgop2)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
end
function s.tgcon2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return false end
	local tc=e:GetLabelObject()
	if not tc or tc:GetFlagEffect(id)==0 or Duel.GetFlagEffect(tp,id)~=0 then
		e:Reset()
		return false
	end
	return true
end
function s.tgop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message(3)
	return eg:IsContains(e:GetLabelObject())
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,EFFECT_FLAG_OATH,1)
end