--魔导栗子球
local m=11561067
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,c11561067.mat,1,1)
	c:EnableReviveLimit()
	--dis
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,11561067)
	e1:SetCondition(c11561067.discon)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c11561067.distg)
	e1:SetOperation(c11561067.disop)
	c:RegisterEffect(e1)
	
end
function c11561067.mat(c)
	return c:IsLinkRace(RACE_FIEND) and not c:IsLinkType(TYPE_LINK)
end

function c11561067.discfilter(c,tp)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsControler(tp)
end
function c11561067.discon(e,tp,eg,ep,ev,re,r,rp)
	if not  re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c11561067.discfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c11561067.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c11561067.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end