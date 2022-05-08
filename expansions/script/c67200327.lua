--结天缘使 征炎众临
function c67200327.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c67200327.condition)
	e1:SetTarget(c67200327.target)
	e1:SetOperation(c67200327.activate)
	c:RegisterEffect(e1)
end
function c67200327.actfilter(c)
	return c:IsFaceup() and c:GetSequence()<5
end
function c67200327.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
		and Duel.IsExistingMatchingCard(c67200327.actfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c67200327.dfilter(c)
	return c:IsSetCard(0x671) and c:IsLevelAbove(1) and c:IsAbleToHand()
end
function c67200327.filter(c,e,tp)
	return c:IsSetCard(0x671)
end
function c67200327.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp) 
		mg:Remove(Card.IsLocation,nil,LOCATION_MZONE)
		local dg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c67200327.dfilter),tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
		local res=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,c67200327.filter,e,tp,mg,dg,Card.GetLevel,"Equal")
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c67200327.activate(e,tp,eg,ep,ev,re,r,rp)
	local m=Duel.GetRitualMaterial(tp)
	m:Remove(Card.IsLocation,nil,LOCATION_MZONE)
	local dg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c67200327.dfilter),tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,c67200327.filter,e,tp,m,dg,Card.GetLevel,"Equal")
	local tc=tg:GetFirst()
	if tc then
		local mg=m:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(dg)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Equal")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then
			aux.RCheckAdditional=nil
			aux.RGCheckAdditional=nil
			return
		end
		tc:SetMaterial(mat)
		local dmat=mat:Filter(Card.IsLocation,nil,LOCATION_MZONE+LOCATION_GRAVE)
		if dmat:GetCount()>0 then
			mat:Sub(dmat)
			Duel.SendtoHand(dmat,nil,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetTarget(c67200327.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c67200327.splimit(e,c)
	return c:IsLocation(LOCATION_DECK) or c:IsLocation(LOCATION_EXTRA) and c:IsLevelAbove(5)
end
