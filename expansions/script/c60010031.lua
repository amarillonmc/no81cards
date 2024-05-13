--米莎-美梦华侍-
local cm,m,o=GetID()
function cm.initial_effect(c)   
	aux.AddCodeList(c,60010029)
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)   
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)  
	e1:SetOperation(cm.op)  
	c:RegisterEffect(e1)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m+10000000)   
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
end
function cm.cfilter(c,race,att)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and bit.band(race,c:GetOriginalRace())==0 and bit.band(att,c:GetOriginalAttribute())==0
end
function cm.tgfilter(c,ft)  
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and ((c:IsLocation(LOCATION_HAND) and ft>0) or c:IsLocation(LOCATION_MZONE))
end 
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local ag=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local bg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil,e:GetHandler():GetOriginalRace(),e:GetHandler():GetOriginalAttribute())
	return (g:GetCount()==0 or ag:GetCount()==bg:GetCount())
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler(),ft) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if not c:IsRelateToEffect(e) then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler(),ft)
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end 
end  
function cm.thfilter(c)
	return c:IsCode(60010029)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) or (Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_FZONE,0,1,nil) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_FZONE,0,1,nil) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil):Select(tp,1,2,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
	else	
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end