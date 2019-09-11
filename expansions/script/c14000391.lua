--荒碑降诞之地
local m=14000391
local cm=_G["c"..m]
cm.named_with_Gravalond=1
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--send to gy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
end
function cm.Grava(c)
	local m=_G["c"..c:GetCode()]
	return m and (m.named_with_Gravalond or c:IsCode(14000380))
end
function cm.filter(c)
	return c:IsCode(14000380)
end
function cm.tgfilter(c)
	return c:IsCode(14000380) and c:IsAbleToGrave()
end
function cm.spfilter(c,e,tp)
	return cm.Grava(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.thfilter1(c)
	return c:IsCode(14000390) and c:IsAbleToHand()
end
function cm.thfilter2(c)
	return c:IsCode(14000395) and c:IsAbleToHand()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
			local ct=Duel.GetMatchingGroupCount(cm.filter,tp,LOCATION_GRAVE,0,nil)
			if ct>=1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,cm.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
				if g:GetCount()>0 then
					if Duel.SendtoHand(g,tp,REASON_EFFECT)~=0 then
						Duel.ConfirmCards(1-tp,g)
						Duel.ShuffleHand(tp)
						Duel.BreakEffect()
						Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
					end
				end
			end
			if ct>=3 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
				if g:GetCount()>0 then
					Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
				end
			end
			if ct>=5 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
				if g:GetCount()>0 then
					if Duel.SendtoHand(g,tp,REASON_EFFECT)~=0 then
						Duel.ConfirmCards(1-tp,g)
					end
				end
			end
		end
	end
end