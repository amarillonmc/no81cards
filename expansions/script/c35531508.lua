--灰流丽·欺负小蓝
function c35531508.initial_effect(c)
	aux.AddCodeList(c,14558127) 
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()	
	--deckdes
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,35531508) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) end)
	e1:SetTarget(c35531508.ddtg)
	e1:SetOperation(c35531508.ddop)
	c:RegisterEffect(e1) 
	--to hand 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,15531508) 
	e1:SetCost(c35531508.srcost)
	e1:SetTarget(c35531508.srtg)
	e1:SetOperation(c35531508.srop)
	c:RegisterEffect(e1)
end
function c35531508.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c35531508.thfil(c) 
	return (c:IsCode(14558127) or aux.IsCodeListed(c,14558127)) and c:IsAbleToHand()
end 
function c35531508.ddop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.DiscardDeck(tp,2,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c35531508.thfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(35531508,0)) then 
		Duel.BreakEffect()
		local sc=Duel.SelectMatchingCard(tp,c35531508.thfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
		Duel.SendtoHand(sc,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sc) 
	end 
end
function c35531508.srcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c35531508.thgck(g) 
	return g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)==1 
	   and g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)==1  
end 
function c35531508.srtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c35531508.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if chk==0 then return g:CheckSubGroup(c35531508.thgck,2,2) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c35531508.srop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c35531508.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil) 
	if g:CheckSubGroup(c35531508.thgck,2,2) then 
		local sg=g:SelectSubGroup(tp,c35531508.thgck,false,2,2) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
	end 
end 










