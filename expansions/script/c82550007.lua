--兽神钢战-终极断空我
function c82550007.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),8,4)
	c:EnableReviveLimit()
	 --cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c82550007.idcon) 
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCondition(c82550007.idcon) 
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	--hand to deck
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c82550007.tgcon)
	e4:SetCost(c82550007.tgcost)
	e4:SetTarget(c82550007.tgtg)
	e4:SetOperation(c82550007.tgop)
	c:RegisterEffect(e4)
	--to deck
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_HANDES)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BATTLE_DAMAGE)
	e6:SetCondition(c82550007.arcondition)
	e6:SetTarget(c82550007.artarget)
	e6:SetOperation(c82550007.aroperation)
	c:RegisterEffect(e6)
end
function c82550007.idcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():GetClassCount(Card.GetCode)>=2
end
function c82550007.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()  and e:GetHandler():GetOverlayGroup():GetClassCount(Card.GetCode)>=3
end
function c82550007.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c82550007.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND)
end
function c82550007.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0,nil)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
function c82550007.arcondition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetOverlayGroup():GetClassCount(Card.GetCode)>=4
end
function c82550007.artarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c82550007.aroperation(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end