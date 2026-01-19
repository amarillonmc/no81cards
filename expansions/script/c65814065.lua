--起义呐喊 星港
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
	--
	local e51=Effect.CreateEffect(c)
	e51:SetDescription(aux.Stringid(id,1))
	e51:SetCategory(CATEGORY_TOHAND)
	e51:SetType(EFFECT_TYPE_QUICK_O)
	e51:SetCode(EVENT_FREE_CHAIN)
	e51:SetRange(LOCATION_SZONE)
	e51:SetTarget(s.tg)
	e51:SetOperation(s.op)
	c:RegisterEffect(e51)
end

function s.ffilter(c,e,tp,ft)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6a31) and c:IsRace(RACE_MACHINE) and c:IsLevelAbove(7) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(s.ffilter,tp,LOCATION_DECK,0,1,nil,e,tp,ft) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,c) and Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.ffilter),tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if not Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,c) then return end
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,c)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_RULE)
	end
end

function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler()
	if chk==0 then return ec:IsAbleToHand() and Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,ec,1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SendtoHand(c,nil,REASON_EFFECT)==0 or c:GetLocation()~=LOCATION_HAND or Duel.GetMatchingGroup(Card.IsSSetable,tp,LOCATION_HAND,0,nil)==0 or  not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then return end 
	local g1=Duel.SelectMatchingCard(tp,Card.IsSSetable,tp,LOCATION_HAND,0,1,1,nil)
	if g1:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		Duel.SSet(tp,g1:GetFirst(),tp,false)
	end
end