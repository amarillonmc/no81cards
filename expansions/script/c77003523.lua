--灵械姬 龙萱
local m=77003523
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3eec),8,2)
	c:EnableReviveLimit()
	--Effect 1
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e01:SetProperty(EFFECT_FLAG_DELAY)
	e01:SetCode(EVENT_SPSUMMON_SUCCESS)
	e01:SetCountLimit(1,m)
	e01:SetCondition(cm.hcon)
	e01:SetTarget(cm.htg)
	e01:SetOperation(cm.hop)
	c:RegisterEffect(e01)
	--Effect 2  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(cm.indes)
	c:RegisterEffect(e2)
	--Effect 3 
	local e02=Effect.CreateEffect(c)  
	e02:SetDescription(aux.Stringid(m,0))
	e02:SetCategory(CATEGORY_DRAW+CATEGORY_DAMAGE)
	e02:SetType(EFFECT_TYPE_IGNITION)
	e02:SetRange(LOCATION_MZONE)
	e02:SetCountLimit(1,m+m)
	e02:SetCost(cm.drcost)
	e02:SetTarget(cm.drtg)
	e02:SetOperation(cm.drop)
	c:RegisterEffect(e02)  
end
--Effect 1
function cm.hcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_XYZ)
end 
function cm.htg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsCanOverlay,tp,0,LOCATION_HAND,nil)
	if chk==0 then return #g>0 end
end
function cm.hop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsCanOverlay,tp,0,LOCATION_HAND,nil)
	if #g==0 then return end
	if not (c:IsRelateToChain() and c:IsType(TYPE_XYZ)) then return false end
	local tag=g:RandomSelect(tp,1)
	if #tag==0 then return end
	Duel.HintSelection(tag)
	Duel.Overlay(c,tag)
end
--Effect 2
function cm.indes(e,c)
	return not c:IsRace(RACE_MACHINE)
end
--Effect 3 
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	if tc:IsRace(RACE_MACHINE) then
		Duel.Damage(1-tp,tc:GetLevel()*100,REASON_EFFECT)
	end
	Duel.ShuffleHand(tp)
end