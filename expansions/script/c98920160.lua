--新宇宙选择进化
function c98920160.initial_effect(c)
 --activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98920160+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c98920160.condition)
	e1:SetCost(c98920160.cost)
	e1:SetTarget(c98920160.target)
	e1:SetOperation(c98920160.activate)
	c:RegisterEffect(e1)
--return replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(c98920160.reptg2)
	e3:SetOperation(c98920160.repop2)
	e3:SetValue(c98920160.repval2)
	c:RegisterEffect(e3)
end
function c98920160.cfilter0(c)
	return c:IsFaceup() and c:IsCode(89943723)
end
function c98920160.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98920160.cfilter0,tp,LOCATION_ONFIELD,0,1,nil)
end
function c98920160.cfilter(c,e,tp)
	return c:IsSetCard(0x1f) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsAbleToGraveAsCost()
		and Duel.GetMZoneCount(tp,c)>0 and Duel.IsExistingMatchingCard(c98920160.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetCode())
end
function c98920160.cost(e,tp,eg,ep,ev,re,r,rp,chk)   
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c98920160.cfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupEx(tp,c98920160.cfilter,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.Release(g,REASON_COST)
end
function c98920160.filter(c,e,tp,code)
	return c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,code) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c98920160.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98920160.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920160.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,code)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c98920160.repfilter2(c,tp,re)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and aux.IsMaterialListCode(c,89943723) and c:IsType(TYPE_FUSION)
		and c:GetDestination()==LOCATION_DECK and re:GetOwner()==c
end
function c98920160.reptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bit.band(r,REASON_EFFECT)~=0 and re
		and e:GetHandler():IsAbleToRemove() and eg:IsExists(c98920160.repfilter2,1,nil,tp,re) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(98920160,1)) then
		return true
	else return false end
end
function c98920160.repop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c98920160.repval2(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsLocation(LOCATION_MZONE) and aux.IsMaterialListCode(c,89943723) and c:IsType(TYPE_FUSION)
end