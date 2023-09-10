--念动力呼唤者/爆裂体
function c98920675.initial_effect(c)
	aux.AddCodeList(c,98920674)
	c:EnableReviveLimit()
	--Cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--ssp
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98920675)
	e1:SetCost(c98920675.cost)
	e1:SetTarget(c98920675.target)
	e1:SetOperation(c98920675.activate)
	c:RegisterEffect(e1)
	 --spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920675,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,98930675)
	e2:SetCondition(c98920675.spcon)
	e2:SetTarget(c98920675.sptg)
	e2:SetOperation(c98920675.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c98920675.descon)
	c:RegisterEffect(e3)
end
c98920675.assault_name=98920674
function c98920675.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c98920675.filter1(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and Duel.GetMZoneCount(tp,c)>0 and ((Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE) and c:IsLocation(LOCATION_EXTRA)) or c:IsLocation(LOCATION_MZONE))
		and Duel.IsExistingMatchingCard(c98920675.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c98920675.filter2(c,e,tp,tcode)
	return c:IsSetCard(0x104f) and c.assault_name==tcode and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP)
end
function c98920675.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c98920675.filter1,tp,LOCATION_MZONE+LOCATION_EXTRA,0,1,nil,e,tp)
	end
	local rg=Duel.SelectMatchingCard(tp,c98920675.filter1,tp,LOCATION_MZONE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetCode())
	Duel.SendtoGrave(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c98920675.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c98920675.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,e:GetLabel()):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)>0 then
		tc:CompleteProcedure()
	end
end
function c98920675.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c98920675.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c98920675.spfilter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920675.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98920675.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c98920675.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c98920675.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c98920675.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end