--和光同尘
local cm,m,o=GetID()
function c13000772.initial_effect(c)
	 c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.check,cm.xyzcheck,2,2)
local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCountLimit(1,m)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2)
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	e3:SetCountLimit(1,m+1000)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(cm.cost2)
	e3:SetTarget(cm.tg2)
	e3:SetOperation(cm.op2)
	c:RegisterEffect(e3)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local mc=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,mc) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local mc=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,mc)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,sg:GetFirst(),nil)
	end
end

function cm.check(c)
	return c:GetRank()>0
end 
function cm.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end
function cm.sprcon(e,c)
	if c==nil then return true end
	return Duel.CheckRemoveOverlayCard(tp,1,0,2,REASON_EFFECT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
   Duel.RemoveOverlayCard(tp,1,0,2,2,REASON_EFFECT)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,c,TYPE_XYZ) then
		local aa=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_MZONE,0,1,1,c,TYPE_XYZ):GetFirst()
		Duel.Overlay(aa,c)
	end
end


















