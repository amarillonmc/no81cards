--唤星号手
local m=40010078
local cm=_G["c"..m]
function cm.BLASTER(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_BLASTER
end
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,2,true)  
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.thcon)
	e1:SetCost(cm.thcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)  
	--atk&def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(300)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_WARRIOR))
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
end
function cm.ffilter(c)
	return cm.BLASTER(c) 
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.cfilter1(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAbleToRemoveAsCost()
end
function cm.cfilter2(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,cm.cfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function cm.thfilter1(c)
	return c:IsCode(40009261) and c:IsAbleToHand()
end
function cm.thfilter2(c)
	return cm.BLASTER(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetFirstMatchingCard(cm.thfilter1,tp,LOCATION_DECK,0,nil)
	if tg then
		if Duel.SendtoHand(tg,nil,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_GRAVE,0,1,nil) then
			Duel.ConfirmCards(1-tp,tg)
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
	end
end


