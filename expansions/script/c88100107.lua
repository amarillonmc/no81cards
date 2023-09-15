--螺旋变升 奇迹☆蓝莓
function c88100107.initial_effect(c)
	aux.AddXyzProcedureLevelFree(c,c88100107.mfilter,nil,6,6)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c88100107.imcon)
	e1:SetValue(c88100107.efilter)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88100107,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c88100107.discon)
	e2:SetCost(c88100107.discost)
	e2:SetTarget(c88100107.distg)
	e2:SetOperation(c88100107.disop)
	c:RegisterEffect(e2)
end
function c88100107.mfilter(c,xyzc)
	return not c:IsLevel(12) and c:IsLevelAbove(1)
end
function c88100107.imcon(e)
	return e:GetHandler():GetOverlayCount()>=6
end
function c88100107.efilter(e,te)
	return not te:GetOwner():IsRank(12)
end
function c88100107.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:GetHandler():IsRelateToEffect(re) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c88100107.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c88100107.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c88100107.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if c:IsRelateToEffect(e) and rc:IsRelateToEffect(re) and rc:IsCanOverlay() and c:IsType(TYPE_XYZ) then
		rc:CancelToGrave()
		local og=rc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(rc))
		if c:GetOverlayGroup():Filter(Card.IsFusionType,nil,TYPE_XYZ):GetClassCount(Card.GetCode)>3 and Duel.SelectYesNo(tp,aux.Stringid(88100107,1)) then
			Duel.NegateEffect(ev)
		end
	end
end