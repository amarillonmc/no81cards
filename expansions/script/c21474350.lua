--
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,40383551)
	--add fusion/fiend
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(s.thtg(s.filter))
	e1:SetOperation(s.thop(s.filter))
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.setcon)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end
function s.filter(c)
	return c:IsCode(40383551)  and c:IsAbleToHand()
end
function s.ifilter(c)
	return c:IsRace(RACE_ILLUSION) and c:IsAbleToHand()
end
function s.thtg(f)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then return Duel.IsExistingMatchingCard(f,tp,LOCATION_DECK,0,1,nil) end
				Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
			end
end
function s.thop(f)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,f,tp,LOCATION_DECK,0,1,1,nil)
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return  rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)
		and rc:GetType()==TYPE_TRAP and rc:IsRelateToEffect(re) and rc:IsCanTurnSet() and rc:IsStatus(STATUS_LEAVE_CONFIRMED) and rc:IsCode(40383551)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.SelectEffectYesNo(tp,rc,aux.Stringid(id,0)) then
		rc:CancelToGrave()
		Duel.ChangePosition(rc,POS_FACEDOWN)
		Duel.RaiseEvent(rc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,0)
	end
end
