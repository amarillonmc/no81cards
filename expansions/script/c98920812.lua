--混沌之青魔道士 混沌战士
function c98920812.initial_effect(c)
	c:EnableReviveLimit()
	c:EnableCounterPermit(0x1)
	c:SetCounterLimit(0x1,3)
	--ritual level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_RITUAL_LEVEL)
	e2:SetValue(c98920812.rlevel)
	c:RegisterEffect(e2)
	--add counter
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c98920812.acop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920812,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,98920812)
	e2:SetCost(c98920812.spcost)
	e2:SetTarget(c98920812.sptg)
	e2:SetOperation(c98920812.spop)
	c:RegisterEffect(e2)
end
function c98920812.rlevel(e,c)
	local lv=aux.GetCappedLevel(e:GetHandler())
	if c:IsSetCard(0xcf) then
		local clv=c:GetLevel()
		return (lv<<16)+clv
	else return lv end
end
function c98920812.acop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(FLAG_ID_CHAINING)>0 then
		e:GetHandler():AddCounter(0x1,1)
	end
end
function c98920812.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0x1)>0 and e:GetHandler():IsReleasable() end
	e:SetLabel(e:GetHandler():GetCounter(0x1))
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c98920812.filter(c,e,tp)
	return (c:IsSetCard(0xbd) or c:IsSetCard(0x10cf)) and not c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c98920812.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c98920812.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c98920812.spop(e,tp,eg,ep,ev,re,r,rp)
	local lt=e:GetLabel()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if lt>ft then lt=ft end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98920812.filter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,lt,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end