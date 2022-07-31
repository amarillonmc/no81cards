--破碎世界 偏离的岔路
function c6160508.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c6160508.target)
	e1:SetOperation(c6160508.activate)
	c:RegisterEffect(e1)	
end
function c6160508.filter(c,e,tp)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function c6160508.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsType,nil,TYPE_MONSTER)
		local mg2=nil
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,c6160508.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c6160508.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsType,nil,TYPE_MONSTER)
	local mg2=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,c6160508.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if mg2 then
			mg:Merge(mg2)
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
		Duel.Release(mat,REASON_EFFECT)
		Duel.SendtoGrave(tc,REASON_EFFECT)
		tc:RegisterFlagEffect(6160508,RESET_EVENT+RESETS_STANDARD,0,1)
		local count=mat:GetCount()
		if tc:IsPreviousLocation(LOCATION_HAND) then
			count=count+1
		end
		Duel.Draw(tp,count,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(c6160508.spcon)
		e1:SetOperation(c6160508.spop)
		if Duel.GetCurrentPhase()<=PHASE_END then
			e1:SetReset(RESET_PHASE+PHASE_END,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_END)
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function c6160508.spfilter(c,e,tp)
	return c:GetFlagEffect(6160508)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c6160508.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c6160508.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function c6160508.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,6160508)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c6160508.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end