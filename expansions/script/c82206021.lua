local m=82206021
local cm=_G["c"..m]
cm.name="植占师1-太阳"
function cm.initial_effect(c)  
	--link summon  
	aux.AddLinkProcedure(c,cm.mfilter,1,1)  
	c:EnableReviveLimit()  
	--tohand  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetCountLimit(1,m)   
	e1:SetTarget(cm.thtg)  
	e1:SetOperation(cm.thop)  
	c:RegisterEffect(e1)   
end  
function cm.mfilter(c)  
	return c:IsLinkRace(RACE_PLANT) and not c:IsCode(m)
end  
function cm.thfilter(c)  
	return c:IsCode(82206020) and c:IsAbleToHand()  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  