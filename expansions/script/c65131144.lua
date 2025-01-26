--秘计螺旋 无惧
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--lp up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.recon)
	e2:SetOperation(s.reop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_RECOVER)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(s.mtcon)
	e4:SetOperation(s.mtop)
	c:RegisterEffect(e4)
end
function s.recon(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(Card.IsFacedown,nil)>0
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	local count=eg:FilterCount(Card.IsFacedown,nil)
	Duel.Recover(tp,count*300,REASON_EFFECT)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function s.thfilter(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.mtfilter(c)
	return c:IsSSetable() or c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.mtfilter,tp,LOCATION_HAND,0,nil)
	local tc=g:CancelableSelect(tp,1,1,nil):GetFirst()
	if tc then
		if not tc:IsAbleToRemoveAsCost(POS_FACEDOWN) or Duel.SelectOption(tp,1153,1192)==0 then
			Duel.SSet(tp,tc)
		else
			Duel.Remove(tc,POS_FACEDOWN,REASON_COST)
		end
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end