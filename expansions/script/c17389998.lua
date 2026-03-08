--终烬降临
local s,id=GetID()
function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	
end

local LOC_ALL_BUT_DECK = LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED
function s.confilter(c)
	return c:IsSetCard(0x5f51)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(s.confilter,tp,LOC_ALL_BUT_DECK,0,e:GetHandler())
		return g:GetClassCount(Card.GetCode)>=18
	end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.confilter,tp,LOC_ALL_BUT_DECK,0,c)	
	if g:GetClassCount(Card.GetCode)<18 then return end
	local confirm_g=Group.CreateGroup()
	local tmp_g=g:Clone()	
	for i=1,18 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=tmp_g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		confirm_g:AddCard(tc)
		tmp_g:Remove(Card.IsCode,nil,tc:GetCode())
	end
	Duel.ConfirmCards(tp,confirm_g)
	Duel.ConfirmCards(1-tp,confirm_g)
	local check=Duel.IsExistingMatchingCard(function(c) 
		return c:IsCode(17390000) and c:IsFaceup() and c:GetOverlayCount()==0 
	end,tp,LOCATION_MZONE,0,1,nil)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-10000)
	if not check then
		Duel.SetLP(tp,Duel.GetLP(tp)-10000)
	end
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end