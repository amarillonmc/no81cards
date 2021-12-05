--尸解"
function c53700000.initial_effect(c)
	aux.AddCodeList(c,53700001,53700002,53700003,53700004)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c53700000.target)
	e1:SetOperation(c53700000.activate)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(2,53700000)
	e2:SetCondition(c53700000.skcon)
	e2:SetTarget(c53700000.sktg)
	e2:SetOperation(c53700000.skop)
	c:RegisterEffect(e2)
end
function c53700000.filter(c,e,tp)
	return c:IsCode(53700002,53700003,53700004)
end
function c53700000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsCode,nil,53700001)
		local mg2=nil
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c53700000.filter,e,tp,mg,mg2,Card.GetLevel,"Equal")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c53700000.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsCode,nil,53700001)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local mg2=nil
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,c53700000.filter,e,tp,mg,mg2,Card.GetLevel,"Equal")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Equal")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c53700000.rccfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL)
end
function c53700000.skcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c53700000.rccfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c53700000.sktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,53700001,0,0x4011,0,0,2,RACE_ZOMBIE,ATTRIBUTE_LIGHT) and e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c53700000.rfilter(c,tp)
	return c:IsCode(53700001) and c:IsLevelAbove(1) and (c:IsControler(tp) or c:IsFaceup())
end
function c53700000.fselect(g,tp)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetLevel,4) and aux.mzctcheckrel(g,tp)
end
function c53700000.skop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetReleaseGroup(tp):Filter(c53700000.rfilter,nil,tp)
	if Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT) and g:CheckSubGroup(c53700000.fselect,1,g:GetCount(),tp) and Duel.IsPlayerCanSpecialSummonMonster(tp,53700001,0,0x4011,0,0,2,RACE_ZOMBIE,ATTRIBUTE_LIGHT) and Duel.SelectYesNo(tp,aux.Stringid(53700000,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local rg=g:SelectSubGroup(tp,c53700000.fselect,false,1,g:GetCount(),tp)
		if Duel.Release(rg,REASON_EFFECT) then
			local token=Duel.CreateToken(tp,53700001)
			if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end
