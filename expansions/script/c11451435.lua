--波动武士·引力波发生装置
local m=11451435
local cm=_G["c"..m]
function cm.initial_effect(c)
	--add to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.adcon)
	e1:SetCost(cm.adcost)
	e1:SetTarget(cm.adtg)
	e1:SetOperation(cm.adop)
	c:RegisterEffect(e1)
end
function cm.lvsum(c,e,tp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	return g:GetSum(Card.GetLevel)
end
function cm.lvsum2(c,e,tp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	return g:GetSum(Card.GetLevel)
end
function cm.adcon(e,c)
	return cm.lvsum(c,e,tp)~=0
end
function cm.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost(POS_FACEDOWN) end
	Duel.ConfirmCards(1-tp,e:GetHandler())
	Duel.Remove(e:GetHandler(),POS_FACEDOWN,REASON_COST)
end
function cm.filter(c,e,tp)
	return c:IsRace(RACE_PSYCHO) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and (cm.lvsum(c,e,tp)%c:GetLevel()==0)
end
function cm.filter2(c,e,tp)
	return c:IsRace(RACE_PSYCHO) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and (cm.lvsum2(c,e,tp)%c:GetLevel()==0)
end
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()==0 then return end
	local ct=math.min(2,g:GetClassCount(Card.GetLevel))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,aux.dlvcheck,false,1,ct)
	if sg:GetCount()>0 then
		local tc=Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		if tc==2 then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetTargetRange(1,0)
			e3:SetTarget(function(e,c) return not c:IsRace(RACE_PSYCHO) end)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
		end
	end
end