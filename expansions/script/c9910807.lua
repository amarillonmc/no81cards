--天体震荡
function c9910807.initial_effect(c)
	aux.AddCodeList(c,9910803)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9910807.target)
	e1:SetOperation(c9910807.activate)
	c:RegisterEffect(e1)
end
function c9910807.filter(c,e,tp,m)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsRace(RACE_DRAGON+RACE_SEASERPENT+RACE_WYRM)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	if c.mat_filter then
		m=m:Filter(c.mat_filter,c,tp)
	else
		m=m:Filter(aux.TRUE,c)
	end
	local b1=Duel.GetMZoneCount(tp)>0 and m:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
	local b2=Duel.GetMZoneCount(tp)<=0 and m:IsExists(c9910807.filter2,1,nil,tp,m,c)
	return b1 or b2
end
function c9910807.filter2(c,tp,m,mc)
	if Duel.GetMZoneCount(tp,c)<=0 then return false end
	local dm=m:Filter(aux.TRUE,c)
	local dlv=mc:GetLevel()-c:GetRitualLevel(mc)
	return dlv<=0 or dm:CheckSubGroup(c9910807.gselect,1,#dm,dlv,mc)
end
function c9910807.gselect(g,dlv,mc)
	return g:GetSum(Card.GetRitualLevel,mc)<mc:GetLevel() and g:CheckWithSumGreater(Card.GetRitualLevel,dlv,mc)
end
function c9910807.mfilter1(c)
	return c:GetLevel()>0
end
function c9910807.mfilter2(c)
	return c:GetLevel()>0 and c:IsFaceup() and c:IsReleasable()
end
function c9910807.mfilter3(c,e)
	return c:GetLevel()>0 and not c:IsImmuneToEffect(e) and c:IsDestructable(e)
end
function c9910807.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetMatchingGroup(c9910807.mfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		local mg2=Duel.GetMatchingGroup(c9910807.mfilter2,tp,LOCATION_EXTRA,0,nil)
		mg1:Merge(mg2)
		return Duel.IsExistingMatchingCard(c9910807.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c9910807.thfilter(c)
	return c:IsSetCard(0x6954) and c:IsAbleToHand()
end
function c9910807.activate(e,tp,eg,ep,ev,re,r,rp)
	local res=false
	local mg1=Duel.GetMatchingGroup(c9910807.mfilter3,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
	local mg2=Duel.GetMatchingGroup(c9910807.mfilter2,tp,LOCATION_EXTRA,0,nil)
	mg1:Merge(mg2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910807.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg1)
	local tc=g:GetFirst()
	if tc then
		if tc.mat_filter then
			mg1=mg1:Filter(c.mat_filter,tc,tp)
		else
			mg1=mg1:Filter(aux.TRUE,tc)
		end
		if Duel.GetMZoneCount(tp)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910807,0))
			local mat=mg1:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
			res=c9910807.ritual(tc,tp,mat)
		else
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910807,2))
			local mat=mg1:FilterSelect(tp,c9910807.filter2,1,1,nil,tp,mg1,tc)
			local sc=mat:GetFirst()
			local dlv=tc:GetLevel()-sc:GetRitualLevel(tc)
			if dlv>0 then
				mg1:RemoveCard(sc)
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910807,3))
				local dg1=mg1:SelectSubGroup(tp,c9910807.gselect,false,1,#mg1,dlv,tc)
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910807,0))
				local dg2=dg1:SelectWithSumGreater(tp,Card.GetRitualLevel,dlv,tc)
				mat:Merge(dg2)
			end
			res=c9910807.ritual(tc,tp,mat)
		end
	end
	if res and tc:IsCode(9910803) and Duel.IsExistingMatchingCard(c9910807.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9910807,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c9910807.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9910807.ritual(tc,tp,mat)
	tc:SetMaterial(mat)
	local mat1=mat:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)
	local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
	local dct=0
	if #mat1>0 then dct=Duel.Destroy(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL) end
	if #mat2>0 then Duel.SendtoGrave(mat2,REASON_RELEASE+REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL) end
	if dct==#mat1 then
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		return true
	end
	return false
end
