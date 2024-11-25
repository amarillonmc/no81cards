--死X进化！
function c16364071.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,16364071)
	e1:SetTarget(c16364071.target)
	e1:SetOperation(c16364071.activate)
	c:RegisterEffect(e1)
end
function c16364071.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xdc3)
		and Duel.IsExistingMatchingCard(c16364071.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,c,rk)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c16364071.filter2(c,e,tp,mc,rk)
	return c:IsRank(rk) and c:IsSetCard(0xdc3) and mc:IsCanBeXyzMaterial(c)
		and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_ZOMBIE)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,true)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c16364071.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c16364071.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c16364071.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c16364071.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c16364071.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c16364071.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tc,tc:GetRank())
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,true,POS_FACEUP)>0 then
			sc:CompleteProcedure()
			local xg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,0xdc3)
			if #xg>0 and Duel.SelectYesNo(tp,aux.Stringid(16364071,0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local sxg=xg:Select(tp,1,1,nil)
				if sxg:GetCount()>=0 then
					Duel.Overlay(sc,sxg)
				end
			end
		end
	end
end