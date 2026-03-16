local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,s.mfilter,nil,2,2)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function s.mfilter(c,xyzc)
	if c:IsXyzLevel(xyzc,2) then return true end
	local tp=xyzc:GetControler()
	if c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) then
		local cg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil)
		for tc in aux.Next(cg) do
			local seq1=c:GetSequence()
			local seq2=tc:GetSequence()
			if seq1<=6 and seq2<=6 then
				local col1=seq1
				if seq1==5 then col1=1 elseif seq1==6 then col1=3 end
				local col2=seq2
				if seq2==5 then col2=1 elseif seq2==6 then col2=3 end
				if math.abs(col1-col2)==1 then return true end
			end
		end
	end
	return false
end
function s.filter1(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c~=e:GetHandler()
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetOriginalCodeRule())
end
function s.filter2(c,e,tp,mc,code)
	return c:IsOriginalCodeRule(code) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL)
		or tc:IsFacedown() or not tc:IsRelateToChain() or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetOriginalCodeRule())
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
		if c:IsRelateToChain() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetLabelObject(sc)
			e1:SetCondition(s.rcon)
			e1:SetOperation(s.rop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end
	end
end
function s.rcon(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetLabelObject()
	return bit.band(r,REASON_COST)~=0 and re:IsActivated() and re:GetHandler()==sc
		and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
		and sc:GetOverlayCount()>=ev-1
end
function s.rop(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end