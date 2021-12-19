--方舟骑士怒号光明
function c29065512.initial_effect(c)
	aux.AddCodeList(c,29065500,29065505)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,29065512+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c29065512.target)
	e1:SetOperation(c29065512.activate)
	c:RegisterEffect(e1)
end
function c29065512.filter1(c,e,tp)
	return c:IsFaceup() and (c:IsSetCard(0x87af) or _G["c"..c:GetCode()].named_with_Arknight) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c29065512.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetOriginalCode())
end
function c29065512.filter2(c,e,tp,mc,code)
	return aux.IsCodeListed(c,code) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c29065512.filter3(c,code)
	return c:IsCode(code) and c:IsFaceup()
end
function c29065512.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065512.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local ct=0
	if Duel.IsExistingMatchingCard(c29065512.filter3,tp,LOCATION_MZONE,0,1,nil,29065500) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(c29065512.filter3,tp,LOCATION_MZONE,0,1,nil,29065505) then ct=ct+1 end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and ct>0 then
		e:SetLabel(1)
		if ct==2 then
			e:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
		end
	else
		e:SetLabel(0)
		e:SetProperty(0)
	end
end
function c29065512.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=1
	if e:GetLabel()==1 then ct=2 end
	while ct>0 do
		local g1=Duel.GetMatchingGroup(c29065512.filter1,tp,LOCATION_MZONE,0,nil,e,tp)
		if g1:GetCount()==0 then return end
		local tc=g1:Select(tp,1,1,nil):GetFirst()
		if not tc or tc:IsImmuneToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c29065512.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetOriginalCode())
		local sc=g2:GetFirst()
		if not sc then return end
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
		ct=ct-1
		g1=Duel.GetMatchingGroup(c29065512.filter1,tp,LOCATION_MZONE,0,nil,e,tp)
		if ct==0 or g1:GetCount()==0 or not Duel.SelectYesNo(tp,aux.Stringid(29065512,0)) then return end
		Duel.BreakEffect()
	end
end
