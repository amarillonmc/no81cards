--泰拉之仪
function c82567785.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(c82567785.target)
	e0:SetOperation(c82567785.operation)
	c:RegisterEffect(e0)
	--AddCounter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,82567785)
	e1:SetTarget(c82567785.cttg)
	e1:SetOperation(c82567785.ctop)
	c:RegisterEffect(e1)
end
function c82567785.filter(c,e,tp)
	return c:IsSetCard(0x825) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function c82567785.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local sg=nil
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c82567785.filter,e,tp,mg,sg,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c82567785.operation(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local sg=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82567785,0))
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,c82567785.filter,e,tp,mg,sg,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if sg then
			mg:Merge(sg)
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
		mat:Sub(mat2)
		Duel.ReleaseRitualMaterial(mat)
		Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

function c82567785.tkfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x825) and c:IsFaceup()
end
function c82567785.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanAddCounter(0x5825,2) and chkc:IsType(TYPE_RITUAL) and chkc:IsSetCard(0x825) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c82567785.tkfilter,tp,LOCATION_MZONE,0,1,nil,0x5825,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c82567785.tkfilter,tp,LOCATION_MZONE,0,1,1,nil,0x5825,2)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0x5825,2)
end
function c82567785.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(tp) and tc:IsSetCard(0x825) and tc:IsType(TYPE_RITUAL)
  then  tc:AddCounter(0x5825,2)
	end
end


