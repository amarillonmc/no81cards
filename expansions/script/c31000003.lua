--Fallacio Herring
function c31000003.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,31000003)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c31000003.spcon)
	e1:SetTarget(c31000003.sptg)
	e1:SetOperation(c31000003.spop)
	c:RegisterEffect(e1)
	--SP Fallacio
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,31000004)
	e2:SetTarget(c31000003.target)
	e2:SetOperation(c31000003.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCountLimit(1)
	e5:SetCondition(c31000003.sycon)
	c:RegisterEffect(e5)
end

function c31000003.spcon(e,tp,eg,ep,ev,re,r,rp)
	local spfilter=function(c)
		return c:IsCode(31000002) and c:IsLevel(e:GetHandler():GetLevel())
	end
	return Duel.IsExistingMatchingCard(spfilter,tp,nil,LOCATION_MZONE,1,nil)
end

function c31000003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c31000003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c31000003.spfilter(c,lv,e,tp)
	return c:IsSetCard(0x308) and not c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c31000003.opfilter(c,e,tp)
	return c:IsCode(31000002) and Duel.IsExistingMatchingCard(c31000003.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,c:GetLevel(),e,tp)
end

function c31000003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c31000003.opfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c31000003.opfilter,tp,0,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c31000003.opfilter,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end

function c31000003.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c31000003.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,c:GetLevel(),e,tp)
	if c:IsRelateToEffect(e) and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc then Duel.IsPlayerCanSpecialSummon(tp,0,POS_FACEUP,tp,tc)
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function c31000003.sycon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_SYNCHRO)
end
