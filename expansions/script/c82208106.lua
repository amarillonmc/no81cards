local m=82208106
local cm=_G["c"..m]
cm.name="鹰身女妖的宠物幻创龙"
function cm.initial_effect(c)
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e1:SetRange(LOCATION_HAND)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCountLimit(1,m)  
	e1:SetCondition(cm.spcon)  
	e1:SetTarget(cm.sptg)  
	e1:SetOperation(cm.spop)  
	c:RegisterEffect(e1)  
	--attribute  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e2:SetCode(EFFECT_ADD_RACE)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetValue(RACE_WINDBEAST)  
	c:RegisterEffect(e2) 
end
function cm.spfilter(c,sp)  
	return c:GetSummonPlayer()==sp 
end  
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(cm.spfilter,1,nil,1-tp)  
end  
function cm.thfilter(c)  
	return c:IsSetCard(0x64) and c:IsAbleToHand() and not c:IsCode(m)
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local ct=Duel.GetMatchingGroupCount(Card.IsSummonType,tp,0,LOCATION_MZONE,nil,SUMMON_TYPE_SPECIAL)  
	if chk==0 then return ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then  
		local ct=Duel.GetMatchingGroupCount(Card.IsSummonType,tp,0,LOCATION_MZONE,nil,SUMMON_TYPE_SPECIAL)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,ct,nil)  
		if g:GetCount()>0 then  
			Duel.SendtoHand(g,nil,REASON_EFFECT)  
			Duel.ConfirmCards(1-tp,g)  
		end  
	end  
end  