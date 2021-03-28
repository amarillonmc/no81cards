--时刻兽 时刻利牙虎
function c40009097.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c40009097.mfilter,6,2,c40009097.ovfilter,aux.Stringid(40009097,0),2,c40009097.xyzop)
	c:EnableReviveLimit()  
	--atk,def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(c40009097.value)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)   
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009097,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c40009097.cost)
	e3:SetTarget(c40009097.target)
	e3:SetOperation(c40009097.operation)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40009097,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c40009097.spcon1)
	e4:SetCost(c40009097.spcost)
	e4:SetTarget(c40009097.sptg)
	e4:SetOperation(c40009097.spop)
	c:RegisterEffect(e4)
	local e7=e4:Clone()
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetHintTiming(0,TIMING_END_PHASE)
	e7:SetCondition(c40009097.spcon2)
	c:RegisterEffect(e7)
end
function c40009097.mfilter(c)
	return c:IsSetCard(0xf17) and c:IsType(TYPE_MONSTER)
end
function c40009097.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf17) and c:IsRace(RACE_BEASTWARRIOR)
end
function c40009097.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,40009097)==0 end
	Duel.RegisterFlagEffect(tp,40009097,RESET_PHASE+PHASE_END,0,1)
end
function c40009097.atkfilter(c)
	return c:GetLevel()>=0
end
function c40009097.value(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c40009097.atkfilter,nil)
	return g:GetSum(Card.GetLevel)*200
end
function c40009097.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c40009097.filter(c,e,tp)
	return c:IsSetCard(0xf17) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40009097.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c40009097.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c40009097.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c40009097.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c40009097.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local lv=tc:GetOriginalLevel()
		local lp=Duel.GetLP(tp)
		Duel.SetLP(tp,lp-lv*300)
	end
end
function c40009097.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>0 and not Duel.IsPlayerAffectedByEffect(tp,40008545)
end
function c40009097.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>0 and Duel.IsPlayerAffectedByEffect(tp,40008545)
end
function c40009097.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c40009097.spfilter(c,e,tp,mc)
	if not (c:IsCode(40008547) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)) then return false end
	if c:IsLocation(LOCATION_EXTRA) then
		return Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
	else
		return Duel.GetMZoneCount(tp,mc)>0
	end
end
function c40009097.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009097.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c40009097.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40009097.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
		if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		g:CompleteProcedure()
	end
end
