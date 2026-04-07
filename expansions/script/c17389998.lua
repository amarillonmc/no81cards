local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,17390000)   
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)   
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,id+1)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,0x5f51)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=18 end
end
function s.dnfilter(c,sg)
	return not sg:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,0x5f51)
	if g:GetClassCount(Card.GetCode)<18 then return end
	local sg=Group.CreateGroup()
	for i=1,18 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local tc=g:FilterSelect(tp,s.dnfilter,1,1,nil,sg):GetFirst()
		if tc then
			sg:AddCard(tc)
		end
	end  
	if #sg==18 then
		Duel.ConfirmCards(1-tp,sg)
		Duel.BreakEffect()
		local chk=Duel.IsExistingMatchingCard(function(c) return c:IsCode(17390000) and c:IsFaceup() and c:GetOverlayCount()==0 end,tp,LOCATION_MZONE,0,1,nil)
		if chk then
			Duel.SetLP(1-tp,Duel.GetLP(1-tp)-10000)
		else
			Duel.SetLP(tp,Duel.GetLP(tp)-10000)
			Duel.SetLP(1-tp,Duel.GetLP(1-tp)-10000)
		end
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetOperation(s.delayed_th)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.delayed_th(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	e:Reset()
	local tc=Duel.GetFirstMatchingCard(function(c) return c:IsCode(id) and c:IsAbleToHand() end,tp,LOCATION_GRAVE,0,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end