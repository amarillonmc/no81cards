--绝地激斗的恋慕屋敷
function c9911075.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	aux.AddCodeList(c,9911056)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--def position
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_POSITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c9911075.deftg)
	e2:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,9911075)
	e3:SetTarget(c9911075.thtg)
	e3:SetOperation(c9911075.thop)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9911075,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DETACH_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,9911063)
	e4:SetCondition(c9911075.rmcon)
	e4:SetTarget(c9911075.rmtg)
	e4:SetOperation(c9911075.rmop)
	c:RegisterEffect(e4)
end
function c9911075.deftg(e,c)
	return c:IsFaceup() and c:GetCounter(0x1954)>0
end
function c9911075.thfilter(c)
	return (c:IsCode(9911056) or aux.IsCodeListed(c,9911056)) and c:IsAbleToHand()
end
function c9911075.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911075.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9911075.xfilter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and not c:IsImmuneToEffect(e)
end
function c9911075.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9911075.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local sg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,1,1,nil)
		local sc=sg:GetFirst()
		if sc then
			if not Duel.IsExistingMatchingCard(c9911075.xfilter,tp,LOCATION_MZONE,0,1,nil,e)
				or Duel.SelectOption(tp,aux.Stringid(9911075,0),aux.Stringid(9911075,1))==0 then
				Duel.SendtoGrave(sc,REASON_EFFECT+REASON_DISCARD)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
				local tc=Duel.SelectMatchingCard(tp,c9911075.xfilter,tp,LOCATION_MZONE,0,1,1,nil,e):GetFirst()
				Duel.Overlay(tc,sg)
			end
		end
	end
end
function c9911075.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE)
end
function c9911075.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c9911075.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	if #sg>0 then
		Duel.HintSelection(sg)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
