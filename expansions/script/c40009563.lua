--焰之巫女 宗妮
local m=40009563
local cm=_G["c"..m]
function cm.initial_effect(c) 
	aux.AddCodeList(c,40009569,40009571)
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m) 
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,m+1)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,4))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,m+1)
	e4:SetCondition(cm.tgcon)
	e4:SetTarget(cm.tgtg)
	e4:SetOperation(cm.tgop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(40009569,40009571) end,tp,LOCATION_ONFIELD,0,1,nil) then return true end 
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return not c:IsPublic() and c:IsCode(40009569,40009571) end,tp,LOCATION_ONFIELD,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,function(c) return not c:IsPublic() and c:IsCode(40009569,40009571) end,tp,LOCATION_ONFIELD,0,1,1,nil) 
	Duel.ConfirmCards(1-tp,g) 
	Duel.ShuffleHand(tp) 
end 
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end 
function cm.plfil(c) 
	return c:IsCode(40009569) and not c:IsForbidden() 
end 
function cm.spfil(c,e,tp) 
	return c:IsCode(40009571) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end 
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local xtable={aux.Stringid(m,1)} 
		if Duel.IsExistingMatchingCard(cm.plfil,tp,LOCATION_HAND,0,1,nil) then table.insert(xtable,aux.Stringid(m,2)) end 
		if Duel.IsExistingMatchingCard(cm.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then table.insert(xtable,aux.Stringid(m,3)) end 
		local op=Duel.SelectOption(tp,table.unpack(xtable))+1  
		if xtable[op]==aux.Stringid(m,2) then 
			local sc=Duel.SelectMatchingCard(tp,cm.plfil,tp,LOCATION_HAND,0,1,1,nil):GetFirst() 
			Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end 
		if xtable[op]==aux.Stringid(m,3) then 
			local sc=Duel.SelectMatchingCard(tp,cm.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst() 
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) 
		end 
	end
end
function cm.cfilter(c)
	return c:IsCode(40009569,40009571) and c:IsFaceup()
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.thfilter(c)
	return c:IsCode(40009569,40009571) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.tgfilter(c)
	return aux.IsCodeListed(c,40009571) and not c:IsCode(m) and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
