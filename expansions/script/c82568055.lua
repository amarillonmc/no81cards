--泰拉机圣的降临
function c82568055.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(c82568055.target)
	e0:SetOperation(c82568055.operation)
	c:RegisterEffect(e0)
	--AddCounter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,82568055)
	e2:SetTarget(c82568055.cttg)
	e2:SetOperation(c82568055.ctop)
	c:RegisterEffect(e2)
end
function c82568055.filter(c,e,tp)
	return c:IsCode(82568053) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c82568055.filter2(c)
	return (c:IsCode(82567786) or c:IsCode(82567787) or c:IsCode(82568086) or c:IsCode(82568087)) and c:IsReleasable()
end
function c82568055.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return
   Duel.IsExistingMatchingCard(c82568055.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	and  Duel.IsExistingMatchingCard(c82568055.filter2,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c82568055.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82568055,1))
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82568055.filter),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=tg:GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=Duel.SelectMatchingCard(tp,c82568055.filter2,tp,LOCATION_MZONE,0,1,1,nil)
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		end
end
function c82568055.tkfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x828) and c:IsFaceup()
end
function c82568055.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanAddCounter(0x5825,2) and chkc:IsType(TYPE_RITUAL) and chkc:IsSetCard(0x828) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c82568055.tkfilter,tp,LOCATION_MZONE,0,1,nil,0x5825,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c82568055.tkfilter,tp,LOCATION_MZONE,0,1,1,nil,0x5825,2)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0x5825,2)
end
function c82568055.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(tp) and tc:IsSetCard(0x825) and tc:IsType(TYPE_RITUAL)
  then  tc:AddCounter(0x5825,2)
	end
end