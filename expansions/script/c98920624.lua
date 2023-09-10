--升阶魔法-异色眼之力
function c98920624.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920624,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,98920624+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c98920624.target)
	e1:SetOperation(c98920624.activate)
	c:RegisterEffect(e1)
end
function c98920624.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsSetCard(0x99) and c:IsType(TYPE_PENDULUM)
		and Duel.IsExistingMatchingCard(c98920624.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+1)
end
function c98920624.filter2(c,e,tp,mc,rk)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x99) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c98920624.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c98920624.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c98920624.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c98920624.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98920624.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920624.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
	local sc=g:GetFirst()
	if sc and Duel.SendtoExtraP(tc,nil,REASON_EFFECT)~=0 then
	   Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	   local g1=Duel.GetMatchingGroup(c98920624.rfilter,tp,LOCATION_GRAVE,0,nil,sc:GetRank())
	   if g1:GetCount()>0 then
		  Duel.BreakEffect()
		  Duel.Overlay(sc,g1)
	   end
	end
end
function c98920624.rfilter(c,rk)
	return c:IsRankBelow(rk-1)
end