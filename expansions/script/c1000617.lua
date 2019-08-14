--超越的圆环 Madoka
function c1000617.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xc204),2)
	--control
	local e99=Effect.CreateEffect(c)
	e99:SetType(EFFECT_TYPE_SINGLE)
	e99:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e99:SetRange(LOCATION_MZONE)
	e99:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e99)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1000617,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c1000617.con1)
	e2:SetTarget(c1000617.sptg)
	e2:SetOperation(c1000617.spop)
	c:RegisterEffect(e2)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(c1000617.con2)
	e1:SetValue(c1000617.efilter1)
	c:RegisterEffect(e1)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c1000617.con3)
	e5:SetValue(c1000617.efilter2)
	c:RegisterEffect(e5)
end
function c1000617.filter9(c,e,tp)
	return c:IsSetCard(0xc204) and c:IsControler(tp)
end
function c1000617.con1(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(c1000617.filter9,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,e,tp)
	local ct=g:GetClassCount(Card.GetCode)
   return  ct>=3
end
function c1000617.spfilter(c,e,tp)
	return c:IsSetCard(0xc204) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1000617.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc==0 then return false end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c1000617.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c1000617.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c1000617.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local g=Duel.GetFirstTarget()
	if g and g:IsRelateToEffect(e) then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
end
function c1000617.con2(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(c1000617.filter9,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,e,tp)
	local ct=g:GetClassCount(Card.GetCode)
   return  ct>=6
end
function c1000617.efilter1(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActiveType(TYPE_MONSTER)
end
function c1000617.con3(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(c1000617.filter9,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,e,tp)
	local ct=g:GetClassCount(Card.GetCode)
   return  ct>=9
end
function c1000617.efilter2(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end