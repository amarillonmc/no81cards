--时机超越
function c40009208.initial_effect(c)
	c:EnableCounterPermit(0xf1c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,40009208+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1) 
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c40009208.ctcon)
	e2:SetOperation(c40009208.ctop)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4) 
	--change effect type
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(40009208)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3) 
	--remove
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(40009208,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c40009208.spcon1)
	e5:SetTarget(c40009208.sptg)
	e5:SetOperation(c40009208.spop)
	c:RegisterEffect(e5) 
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMING_END_PHASE)
	e6:SetCost(c40009208.negcost)
	e6:SetCondition(c40009208.spcon2)
	c:RegisterEffect(e6)	
end
function c40009208.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xf1c,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0xf1c,3,REASON_COST)
end
function c40009208.ctfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xf1c) and c:IsControler(tp)
end
function c40009208.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c40009208.ctfilter,1,nil,tp)
end
function c40009208.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0xf1c,2)
end
function c40009208.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,40009208)
end
function c40009208.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,40009208)
end
function c40009208.filter1(c,e,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c40009208.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) and c:IsSetCard(0xf1c) and c:IsType(TYPE_PENDULUM) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c40009208.filter2(c,e,tp,mc,rk)
	local rk=0
	if mc:IsType(TYPE_XYZ) then
		rk=mc:GetRank()
	else
		rk=mc:GetLevel()
	end
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0xf1c) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and c:GetRank()==rk+1
end
function c40009208.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c40009208.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c40009208.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c40009208.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c40009208.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40009208.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	end
	sc:CompleteProcedure()
end


