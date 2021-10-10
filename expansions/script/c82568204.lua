--AK-Reconnect-仪式
function c82568204.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_FZONE)
	e0:SetCountLimit(1,82568204)
	e0:SetTarget(c82568204.target)
	e0:SetOperation(c82568204.operation)
	c:RegisterEffect(e0)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(c82568204.chainop)
	c:RegisterEffect(e2)
	--add code
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_ADD_CODE)
	e4:SetValue(82567785)
	c:RegisterEffect(e4)
end
function c82568204.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0x828) and ep==tp then
		Duel.SetChainLimit(c82568204.chainlm)
	end
end
function c82568204.chainlm(e,rp,tp)
	return tp==rp
end
function c82568204.filter(c,e,tp)
	return c:IsSetCard(0x825) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function c82568204.lcfilter(c,e,tp)
	return c:IsLocation(LOCATION_ONFIELD)
end
function c82568204.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local mgf=mg:Filter(c82568204.lcfilter,nil)
		local sg=nil
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c82567785.filter,e,tp,mgf,sg,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c82568204.operation(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local mgf=mg:Filter(c82568204.lcfilter,nil)
	local sg=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82568204,0))
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,c82567785.filter,e,tp,mgf,sg,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mgf:Filter(Card.IsCanBeRitualMaterial,tc,tc)
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


