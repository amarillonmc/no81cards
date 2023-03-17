--混沌No.21 绝对零度之正义女郎
local m=13131368
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,3,cm.ovfilter,aux.Stringid(13131368,0),3,cm.xyzop)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13131368,1))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.tgcon)
	e1:SetTarget(cm.postg)
	e1:SetOperation(cm.posop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13131368,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(cm.spcost)
	e3:SetTarget(cm.remtg)
	e3:SetOperation(cm.remop)
	c:RegisterEffect(e3)
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsXyzType(TYPE_XYZ) and c:IsRank(6)
end
function cm.xyzop(e,tp,chk,mc)
	if chk==0 then return mc:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	mc:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(cm.posfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.posfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
function cm.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.rmfilter(c)
	return c:IsDefensePos() and c:IsAbleToRemove()
end
function cm.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cm.remop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_MZONE,nil) 
	local x=Duel.Remove(g,POS_DEFENSE,REASON_EFFECT)
	if e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,57707471) and x>0 then 
		Duel.BreakEffect()
		Duel.Damage(1-tp,800,REASON_EFFECT) 
		if c:IsRelateToEffect(e) then 
		local og=g:Select(tp,1,1,nil) 
		Duel.Overlay(c,og)  
		end 
	end  
end 











