--世界树_7D6
function c16349035.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3dc2))
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(c16349035.val)
	c:RegisterEffect(e1)
	local e11=e1:Clone()
	e11:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e11)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,16349035)
	e2:SetTarget(c16349035.sptg)
	e2:SetOperation(c16349035.spop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c16349035.indcon)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
end
function c16349035.val(e,c)
	return Duel.GetMatchingGroupCount(nil,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)*100
end
function c16349035.tdfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x3dc2) and c:IsAbleToExtra()
		and Duel.IsExistingMatchingCard(c16349035.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c16349035.spfilter(c,e,tp,tc)
	local type=tc:GetType()&(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
	return c:IsSetCard(0x3dc2) and not c:IsType(type) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,tc,c)
end
function c16349035.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c16349035.tdfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c16349035.tdfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c16349035.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA) then	
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c16349035.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c16349035.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3dc2)
end
function c16349035.indcon(e)
	return Duel.IsExistingMatchingCard(c16349035.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end