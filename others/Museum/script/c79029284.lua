--企鹅战法·苹果仪式
function c79029284.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c79029284.target)
	e1:SetOperation(c79029284.activate)
	c:RegisterEffect(e1) 
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c79029284.drcon)
	e2:SetTarget(c79029284.drtg)
	e2:SetOperation(c79029284.drop)
	c:RegisterEffect(e2)   
end
function c79029284.filter(c,e,tp)
	return c:IsRace(RACE_CYBERSE)
end
function c79029284.cfil(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsRace(RACE_CYBERSE)
end
function c79029284.cfilter(c)
	return c:GetLinkedGroup():IsExists(c79029284.cfil,1,nil) and c:IsRace(RACE_CYBERSE)
end
function c79029284.mfilter(c)
	return c:IsReleasable()
end
function c79029284.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local mg2=nil
		if Duel.IsExistingMatchingCard(c79029284.cfilter,tp,LOCATION_MZONE,0,1,nil) then
			mg2=Duel.GetMatchingGroup(aux.RitualExtraFilter,tp,0,LOCATION_MZONE,nil,c79029284.mfilter)
		end
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,c79029284.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	if Duel.IsExistingMatchingCard(c79029284.cfilter,tp,LOCATION_MZONE,0,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c79029284.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local mg2=nil
	if e:GetLabel()==1 then
		mg2=Duel.GetMatchingGroup(aux.RitualExtraFilter,tp,0,LOCATION_MZONE,nil,c79029284.mfilter)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,1,nil,c79029284.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
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
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	Debug.Message("结束后吃点什么好呢？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029284,0))
	end
end
function c79029284.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and rp==1-tp and ev>=2000
		and (re or (Duel.GetAttacker() and Duel.GetAttacker():IsControler(1-tp)))
end
function c79029284.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_CYBERSE)
end
function c79029284.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=math.floor(ev/2000)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029284.spfil,tp,LOCATION_EXTRA,0,d,nil,e,tp) and Duel.GetLocationCountFromEx(tp)>=d
	and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Debug.Message("嗯......抱歉，可以让大家自由行动吗？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029284,1))
	local g=Duel.SelectMatchingCard(tp,c79029284.spfil,tp,LOCATION_EXTRA,0,d,d,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,d,tp,LOCATION_EXTRA)
end
function c79029284.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end






