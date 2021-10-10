--升阶魔法—化神之力
function c82557935.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82557935,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,82557935)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c82557935.target)
	e1:SetOperation(c82557935.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,82557835)
	e2:SetTarget(c82557935.mttg)
	e2:SetOperation(c82557935.mtop)
	c:RegisterEffect(e2)
	
end
function c82557935.xfilter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsSetCard(0x829) and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c82557935.xfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+2)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c82557935.xfilter2(c,e,tp,mc,rk)
	return c:IsRank(rk) and c:IsSetCard(0x829) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c82557935.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c82557935.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c82557935.xfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c82557935.xfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c82557935.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82557935.xfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+2)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
function c82557935.filter1(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x829)
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c82557935.filter2),tp,LOCATION_GRAVE,0,1,c)
end
function c82557935.filter2(c,e)
	return c:IsType(TYPE_MONSTER) 
end
function c82557935.mttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c82557935.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c82557935.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c82557935.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function c82557935.mtop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82557935.filter2),tp,LOCATION_GRAVE,0,1,1,tc,e)
	if g:GetCount()>0 then
		local og=g:GetFirst():GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc,g)
	end
end