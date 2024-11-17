--幻想山河 幽灵船渡守凯伦
local s,id,o=GetID()
function s.initial_effect(c)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.discon)
	e1:SetCost(s.discost)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+10000)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
s.fantasy_mountains_and_rivers=true
function s.disfilter(c)
	return (c:IsType(TYPE_XYZ) or c:IsType(TYPE_FUSION)) and _G["c"..c:GetCode()] and _G["c"..c:GetCode()].fantasy_mountains_and_rivers and c:IsFaceup()
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(s.disfilter,tp,LOCATION_MZONE,0,1,nil)
		and rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
		and (c:IsLocation(LOCATION_MZONE) and not c:IsStatus(STATUS_BATTLE_DESTROYED) or c:IsLocation(LOCATION_HAND))
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g0=Duel.GetFieldGroup(0,LOCATION_ONFIELD,0)
	local g1=Duel.GetFieldGroup(1,LOCATION_ONFIELD,0)
	local sg0=g0:Filter(Card.IsAbleToGraveAsCost,e:GetHandler())
	local sg1=g1:Filter(Card.IsAbleToGraveAsCost,e:GetHandler())
	if chk==0 then
		if #g0>#g1 then
			return e:GetHandler():IsAbleToGraveAsCost() and #sg0>0
		elseif #g0<#g1 then
			return e:GetHandler():IsAbleToGraveAsCost() and #sg1>0
		else
			return false
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	if #g0>#g1 then
		Duel.SendtoGrave(sg0:Select(tp,1,1,nil),REASON_COST)
	elseif #g0<#g1 then
		Duel.SendtoGrave(sg1:Select(tp,1,1,nil),REASON_COST)
	end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,rp,0,LOCATION_ONFIELD,1,nil) end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.repop)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(1-tp,aux.TRUE,1-tp,LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g0=Duel.GetFieldGroup(0,LOCATION_ONFIELD,0)
	local g1=Duel.GetFieldGroup(1,LOCATION_ONFIELD,0)
	local sg0=g0:Filter(Card.IsAbleToGraveAsCost,nil)
	local sg1=g1:Filter(Card.IsAbleToGraveAsCost,nil)
	if chk==0 then
		if #g0>#g1 then
			return #sg0>0
		elseif #g0<#g1 then
			return #sg1>0
		else
			return false
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	if #g0>#g1 then
		Duel.SendtoGrave(sg0:Select(tp,1,1,nil),REASON_COST)
	elseif #g0<#g1 then
		Duel.SendtoGrave(sg1:Select(tp,1,1,nil),REASON_COST)
	end
end
function s.thfilter(c)
	return (_G["c"..c:GetCode()] and _G["c"..c:GetCode()].fantasy_mountains_and_rivers and not c:IsCode(id)) and c:IsType(TYPE_MONSTER)
		and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
