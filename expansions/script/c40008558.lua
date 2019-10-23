--刻兽使·马尼什
function c40008558.initial_effect(c)
	c:SetUniqueOnField(1,0,40008558)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c40008558.cost)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c40008558.sptg)
	e2:SetOperation(c40008558.spop)
	c:RegisterEffect(e2)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(c40008558.sumcon)
	e3:SetOperation(c40008558.sumsuc)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)	 
end
function c40008558.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c40008558.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xf17)
end
function c40008558.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c40008558.filter,1,nil)
end
function c40008558.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c40008558.efun)
end
function c40008558.efun(e,ep,tp)
	return ep==tp
end
function c40008558.tgfilter(c,e,tp)
	local lv=c:GetLevel()
	return c:IsSetCard(0xf17) and lv>0 and Duel.IsExistingMatchingCard(c40008558.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,lv)
end
function c40008558.spfilter(c,e,tp,lv)
	return c:IsLevelBelow(lv) and c:IsSetCard(0xf17) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40008558.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and  c40008558.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c40008558.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c40008558.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c40008558.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c40008558.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tc:GetLevel())
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) 
	end
end