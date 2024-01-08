--桃绯论武
function c9910529.initial_effect(c)
	aux.AddCodeList(c,9910507,9910515,9910527)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9910529.target)
	e1:SetOperation(c9910529.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c9910529.descost)
	e2:SetTarget(c9910529.destg)
	e2:SetOperation(c9910529.desop)
	c:RegisterEffect(e2)
end
function c9910529.atkfilter(c)
	return c:IsFaceup() and c:GetAttack()>c:GetBaseAttack()
end
function c9910529.atkfilter2(c,e)
	return c:IsFaceup() and c:GetAttack()>c:GetBaseAttack()
		and not c:IsImmuneToEffect(e) and not c:IsHasEffect(EFFECT_REVERSE_UPDATE)
end
function c9910529.atkdiff(c,diff)
	return c:GetAttack()>=c:GetBaseAttack()+diff
end
function c9910529.filter2(c,e,tp,atkg)
	if bit.band(c:GetType(),0x81)~=0x81 or Duel.GetLocationCount(tp,LOCATION_MZONE)==0
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
	return atkg:IsExists(c9910529.atkdiff,1,nil,c:GetLevel()*100)
end
function c9910529.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsSetCard,nil,0xa950)
		local atkg=Duel.GetMatchingGroup(c9910529.atkfilter,tp,LOCATION_MZONE,0,nil)
		local b1=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,nil,e,tp,mg,nil,Card.GetLevel,"Greater")
		local b2=Duel.IsExistingMatchingCard(c9910529.filter2,tp,LOCATION_HAND,0,1,nil,e,tp,atkg)
		return b1 or b2
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9910529.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsSetCard,nil,0xa950)
	local atkg=Duel.GetMatchingGroup(c9910529.atkfilter2,tp,LOCATION_MZONE,0,nil,e)
	local g1=Duel.GetMatchingGroup(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,nil,nil,e,tp,mg,nil,Card.GetLevel,"Greater")
	local g2=Duel.GetMatchingGroup(c9910529.filter2,tp,LOCATION_HAND,0,nil,e,tp,atkg)
	g:Merge(g1)
	g:Merge(g2)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if g1:IsContains(tc) and (not g2:IsContains(tc) or Duel.SelectOption(tp,aux.Stringid(9910529,0),aux.Stringid(9910529,1))==0) then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
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
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local atkg2=atkg:FilterSelect(tp,c9910529.atkdiff,1,1,nil,tc:GetLevel()*100)
		if atkg2:GetCount()==0 then return end
		local sc=atkg2:GetFirst()
		local diff=math.abs(sc:GetBaseAttack()-sc:GetAttack())
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-diff)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		tc:SetMaterial(nil)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c9910529.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.CheckReleaseGroupEx(REASON_COST,tp,nil,1,nil) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	local g=Duel.SelectReleaseGroupEx(REASON_COST,tp,nil,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c9910529.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,9910529)==0 end
end
function c9910529.desop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCondition(c9910529.descon2)
	e1:SetOperation(c9910529.desop2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(9910529,2))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,9910529,RESET_PHASE+PHASE_END,0,1)
end
function c9910529.cfilter(c,tp)
	return c:IsFaceup() and c:IsCode(9910507,9910515,9910527) and c:IsControler(tp)
end
function c9910529.desfilter2(c,tp)
	return c:GetColumnGroup():IsExists(c9910529.cfilter,1,nil,tp)
end
function c9910529.descon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9910529.desfilter2,tp,0,LOCATION_ONFIELD,1,nil,tp)
end
function c9910529.desop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910529.desfilter2,tp,0,LOCATION_ONFIELD,nil,tp)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
