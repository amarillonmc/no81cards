-- 新昼地的开拓者 法拉赫
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,47320301)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE),4,2)
	s.search_effect(c)
	s.overlay_effect(c)
end

function s.search_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.setcon)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	 return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.setfilter(c)
	return c:IsSetCard(0x5c17) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.setfilter3(c)
	return aux.IsCodeListed(c,47320301) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(s.setfilter3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g1=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g2=Duel.SelectMatchingCard(tp,s.setfilter3,tp,LOCATION_DECK,0,1,1,nil)
		g1:Merge(g2)
		if #g1>0 then
			Duel.SSet(tp,g1)
		end
	end
end

function s.overlay_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_MOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id-1000)
	e2:SetCondition(s.setcon2)
	e2:SetTarget(s.settg2)
	e2:SetOperation(s.setop2)
	c:RegisterEffect(e2)
end
function s.setcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_XYZ)
		and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function s.setfilter2(c)
	return aux.IsCodeListed(c,47320301) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.settg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter2,tp,LOCATION_GRAVE,0,1,nil) end
end
function s.setop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
