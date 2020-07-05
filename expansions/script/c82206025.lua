local m=82206025
local cm=_G["c"..m]
cm.name="植占师5-星星"
function cm.initial_effect(c)
	--pendulum summon  
	aux.EnablePendulumAttribute(c) 
	--pendulum search 
	local e0=Effect.CreateEffect(c)  
	e0:SetDescription(aux.Stringid(m,0))  
	e0:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)  
	e0:SetType(EFFECT_TYPE_IGNITION) 
	e0:SetCountLimit(1,82226025)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCondition(cm.thcon)
	e0:SetTarget(cm.thtg)  
	e0:SetOperation(cm.thop)  
	c:RegisterEffect(e0)   
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,1))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_RECOVER)
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)  
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)  
	e1:SetOperation(cm.spop)  
	c:RegisterEffect(e1)
	--to hand 
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,2))  
	e2:SetCategory(CATEGORY_TOHAND)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCountLimit(1,82216025)  
	e2:SetTarget(cm.thtg2)  
	e2:SetOperation(cm.thop2)  
	c:RegisterEffect(e2)  
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0x129d)  
end
function cm.thfilter(c)  
	return c:IsSetCard(0x129d) and c:IsAbleToHand() and c:IsAttackBelow(1437)
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.Destroy(c,REASON_EFFECT,LOCATION_GRAVE)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
		if g:GetCount()>0 then  
			Duel.SendtoHand(g,nil,REASON_EFFECT)  
			Duel.ConfirmCards(1-tp,g)  
		end  
	end
end  
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return ep==tp  
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) then return end  
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)  
end  
function cm.thfilter2(c)  
	return c:IsRace(RACE_PLANT) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and c:IsAttackBelow(1437) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) 
end  
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)  
end  
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  