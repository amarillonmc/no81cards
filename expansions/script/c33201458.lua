--混沌圣堂的神罚
local s,id,o=GetID()
Duel.LoadScript("c33201450.lua")
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,4)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.rmcost)
	e1:SetCondition(s.rmcon)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--activate limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(s.actlimit)
	c:RegisterEffect(e4)
end
s.VHisc_hdst=true

function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=e:GetHandler():GetOverlayGroup()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,rg:GetCount(),REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,rg:GetCount(),rg:GetCount(),REASON_COST)
end
function s.rmfilter(c)
	return VHisc_HDST.nck(c) and c:IsAbleToRemove()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,1,nil) end
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,nil)
	Duel.Hint(24,0,aux.Stringid(id,0))
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end

function s.actlimit(e,re,tp)
	local tc=re:GetHandler()
	return VHisc_HDST.nck(tc)
end
