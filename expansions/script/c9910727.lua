--远古造物栖所 冈瓦纳
require("expansions/script/c9910700")
function c9910727.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9910727.target)
	e1:SetOperation(c9910727.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c9910727.setcon)
	e2:SetTarget(c9910727.settg)
	e2:SetOperation(c9910727.setop)
	c:RegisterEffect(e2)
end
function c9910727.cfilter(c,tp)
	return c:IsSetCard(0xc950) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c9910727.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910727.cfilter,tp,LOCATION_HAND,0,1,nil) end
end
function c9910727.thfilter(c,mg)
	return c:IsSetCard(0xc950) and c:IsAbleToHand() and not mg:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function c9910727.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,c9910727.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g1)
	if g1:GetCount()==0 then return end
	local tc=g1:GetFirst()
	local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil)
	if g2:GetCount()>0 then g1:Merge(g2) end
	local g3=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	if g3:GetCount()>0 then g1:Merge(g3) end
	if Duel.IsExistingMatchingCard(c9910727.thfilter,tp,LOCATION_DECK,0,1,nil,g1)
		and Ygzw.SetFilter(tc,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(9910727,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c9910727.thfilter,tp,LOCATION_DECK,0,1,1,nil,g1)
		if #g>0 then
			Duel.BreakEffect()
			if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
				Duel.ConfirmCards(1-tp,g)
				Ygzw.Set(tc,e,tp)
			end
		end
	end
	Duel.ShuffleHand(tp)
end
function c9910727.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
end
function c9910727.setfilter(c,id,e)
	local op=c:GetOwner()
	return c:GetTurnID()==id and c:IsType(TYPE_MONSTER) and c:IsFaceup() and Ygzw.SetFilter(c,e,op)
end
function c9910727.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local id=Duel.GetTurnCount()
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c9910727.setfilter(chkc,id,e) end
	if chk==0 then return Duel.IsExistingTarget(c9910727.setfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,id,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c9910727.setfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,id,e)
end
function c9910727.setop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local op=tc:GetOwner()
	if tc:IsRelateToEffect(e) then
		Ygzw.Set(tc,e,op)
	end
end
