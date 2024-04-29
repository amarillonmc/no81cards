--神碑の翼フギン
local m=91030023
local cm=c91030023
function c91030023.initial_effect(c)
	--fusion material
	 c:SetSPSummonOnce(m)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.matfilter,1,1)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.thcon)
	e1:SetCost(cm.thcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.thtg2)
	e2:SetOperation(cm.thop2)
	c:RegisterEffect(e2)
end
function cm.matfilter(c)
	return c:IsLinkSetCard(0x9d3) and c:IsLinkAttribute(ATTRIBUTE_ALL&~ATTRIBUTE_WATER)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonLocation(LOCATION_EXTRA)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.thfilter1(c)
	return c:IsSetCard(0x9d3) and c:IsType(TYPE_FIELD) and not c:IsForbidden()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end

end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return 
	c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,3,nil,e,tp,cg:GetCount()) end
	local cg1=cg:Select(tp,2,2,c) 
	cg1:AddCard(c)
	Duel.Remove(cg1,POS_FACEUP,REASON_COST)
end

function cm.cfilter(c)
	return c:IsSetCard(0x9d3) and c:IsAbleToRemoveAsCost()  
end
function cm.thfilter(c,tp)
	return c:IsSetCard(0x9d3) and c:IsType(TYPE_SPELL) and c:IsAbleToHand() and c:IsType(TYPE_QUICKPLAY)
		and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
