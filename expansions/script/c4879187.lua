--时隙湮灭
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.sscon)
	e2:SetOperation(s.ssop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1,id+o*2)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp 
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_MZONE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	 local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=g:Select(tp,1,1,nil)
	Duel.HintSelection(sg)
local sg2=sg:GetFirst()
	if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0  then
	Duel.ConfirmCards(1-tp,sg)
 local fg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,nil)
 if #fg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
	Duel.BreakEffect()
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	   local sg1=fg:Select(tp,1,1,nil)
		Duel.HintSelection(sg1)
	  Duel.SendtoDeck(sg1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
 end
	end

end
function s.cfilter(c,tp)
	return c:IsSetCard(0xae5d) and c:GetSummonPlayer()==tp
end
function s.sscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,c,tp)
end
function s.ssop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
 local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		e1:SetLabel(0)
		e1:SetOperation(s.thop1)
		Duel.RegisterEffect(e1,tp)
		s[c]=e1
	c:RegisterFlagEffect(1082946,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,2,0,nil)
	c:RegisterFlagEffect(4879171,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,2,0,nil)
end
function s.thop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
local ct=e:GetLabel()
	c:SetTurnCounter(ct+1)

	if ct+1==2 then
			local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	   if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
	   Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
e:Reset()
		e:GetOwner():ResetFlagEffect(1082946)
e:GetOwner():ResetFlagEffect(4879171)
	end
		else e:SetLabel(ct+1)
	end

end
function s.thfilter(c,e,tp)
	return  c:IsSetCard(0xae5d) and c:IsAbleToGrave()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
