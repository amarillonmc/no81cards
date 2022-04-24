--战车道装甲·百夫长
require("expansions/script/c9910106")
function c9910147.initial_effect(c)
	--xyz summon
	Zcd.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),7,3,c9910147.xyzfilter,aux.Stringid(9910147,0),99)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910147,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910147.rmtg)
	e1:SetOperation(c9910147.rmop)
	c:RegisterEffect(e1)
end
function c9910147.xyzfilter(c)
	return (c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x952) and c:IsFaceup()))
		and c:IsRace(RACE_MACHINE)
end
function c9910147.xmfilter(c,e)
	return c:IsSetCard(0x952) and c:IsCanOverlay() and not (c:IsOnField() and e and c:IsImmuneToEffect(e))
end
function c9910147.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local loc=0
	local xg=Duel.GetMatchingGroup(c9910147.xmfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,c)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if xg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) and rg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND)
		then loc=loc+LOCATION_HAND end
	if xg:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD) and rg:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD)
		then loc=loc+LOCATION_ONFIELD end
	if xg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) and rg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)
		then loc=loc+LOCATION_GRAVE end
	if chk==0 then return c:IsType(TYPE_XYZ) and loc>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c9910147.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local loc=0
	local xg=Duel.GetMatchingGroup(c9910147.xmfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,c,e)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if xg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) and rg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND)
		then loc=loc+LOCATION_HAND end
	if xg:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD) and rg:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD)
		then loc=loc+LOCATION_ONFIELD end
	if xg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) and rg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)
		then loc=loc+LOCATION_GRAVE end
	if loc==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local xc=xg:Select(tp,1,1,nil):GetFirst()
	local rc=nil
	if not xc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if xc:IsLocation(LOCATION_HAND) then
		rc=rg:Filter(Card.IsLocation,nil,LOCATION_HAND):RandomSelect(tp,1):GetFirst()
	elseif xc:IsLocation(LOCATION_ONFIELD) then
		rc=rg:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_ONFIELD):GetFirst()
	elseif xc:IsLocation(LOCATION_GRAVE) then
		rc=rg:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_GRAVE):GetFirst()
	end
	if not rc then return end
	if xc:IsOnField() then
		xc:CancelToGrave()
		local og=xc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
	end
	Duel.Overlay(c,xc)
	Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
end
