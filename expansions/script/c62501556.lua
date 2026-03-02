--联协指令 允许访问
function c62501556.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,62501556)
	e1:SetTarget(c62501556.target)
	e1:SetOperation(c62501556.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(62501556,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,62501556+1)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c62501556.sptg)
	e2:SetOperation(c62501556.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(62501556,2))
	e3:SetTarget(c62501556.spetg)
	e3:SetOperation(c62501556.speop)
	c:RegisterEffect(e3)
end
function c62501556.xfilter(c,e,tp)
	return c:IsSetCard(0xea3) and c:IsRank(6) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c62501556.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c62501556.xfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c62501556.ovfilter(c)
	return c:IsSetCard(0xea3) and aux.NecroValleyFilter()(c) and c:IsCanOverlay()
end
function c62501556.activate(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	local sc=Duel.SelectMatchingCard(tp,c62501556.xfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if sc then
		sc:SetMaterial(nil)
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
		local fid=e:GetHandler():GetFieldID()
		sc:RegisterFlagEffect(62501556,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(sc)
		e1:SetCondition(c62501556.descon)
		e1:SetOperation(c62501556.desop)
		Duel.RegisterEffect(e1,tp)
		if Duel.IsExistingMatchingCard(c62501556.ovfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(62501556,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local sg=Duel.SelectMatchingCard(tp,c62501556.ovfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			Duel.Overlay(sc,sg)
		end
	end
end
function c62501556.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(62501556)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c62501556.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
function c62501556.spfilter(c,e,tp)
	return c:IsSetCard(0xea3) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c62501556.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c62501556.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c62501556.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c62501556.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c62501556.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
		if Duel.IsExistingMatchingCard(c62501556.ovfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(62501556,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local sg=Duel.SelectMatchingCard(tp,c62501556.ovfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			Duel.Overlay(tc,sg)
		end
	end
end
function c62501556.tfilter(c,e)
	return c:IsCode(62501536,62501541,62501531) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx() and c:IsCanBeEffectTarget(e) and c:IsCanOverlay()
end
function c62501556.filter2(c,e,tp)
	return c:IsCode(62501546) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c62501556.fselect(g)
	return g:FilterCount(Card.IsCode,nil,62501536)==1 and g:FilterCount(Card.IsCode,nil,62501541)==1 and g:FilterCount(Card.IsCode,nil,62501531)==1
end
function c62501556.spetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local rg=Duel.GetMatchingGroup(c62501556.tfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,e)
	if chk==0 then return rg:CheckSubGroup(c62501556.fselect,3,3) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=rg:SelectSubGroup(tp,c62501556.fselect,false,3,3)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE),1,0,0)
end
function c62501556.mfilter(c,e)
	return c:IsCanOverlay() and not c:IsImmuneToEffect(e)
end
function c62501556.speop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetsRelateToChain()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c62501556.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		sc:CompleteProcedure()
		local og=tg:Filter(c62501556.mfilter,nil,e)
		for tc in aux.Next(og) do
			local mg=tc:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(sc,mg)
			end
			Duel.Overlay(sc,Group.FromCards(tc))
		end
	end
end
