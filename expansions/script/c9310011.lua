--深土之物 人身单调鸥
function c9310011.initial_effect(c)
	c:EnableReviveLimit()
	--ritual summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9310011)
	e1:SetCost(c9310011.rscost)
	e1:SetTarget(c9310011.tg)
	e1:SetOperation(c9310011.op)
	c:RegisterEffect(e1)
	--flip
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_FLIP)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c9310011.flipop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9310011.indcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--nontuner
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e4)
	--to change pos
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,9311011)
	e5:SetCondition(c9310011.qcon)
	e5:SetCost(c9310011.thcost)
	e5:SetTarget(c9310011.target)
	e5:SetOperation(c9310011.operation)
	c:RegisterEffect(e5)
	local e7=e5:Clone()
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e7:SetCondition(c9310011.qcon1)
	c:RegisterEffect(e7)
end
--quick
function c9310011.qcon(e,tp)
	return not Duel.IsPlayerAffectedByEffect(tp,30013020)
end
function c9310011.qcon1(e,tp)
	return Duel.IsPlayerAffectedByEffect(tp,30013020)
end
--
function c9310011.rscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c9310011.matfilter(c,e,tp,chk)
	return c:IsCanBeRitualMaterial(nil) and (not chk or c~=e:GetHandler())
end
function c9310011.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk)) 
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true,POS_DEFENSE) then return false end
	local mg=m1:Filter(c9310011.matfilter,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lv=level_function(c)
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,lv,greater_or_equal)
	local res=mg:CheckSubGroup(aux.RitualCheck,1,lv,tp,c,lv,greater_or_equal)
	aux.GCheckAdditional=nil
	return res
end
function c9310011.rfilter(c,e,tp)
	return c:IsDefenseAbove(2200) and c:GetDefense()>=c:GetAttack()
end
function c9310011.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		return Duel.IsExistingMatchingCard(c9310011.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c9310011.rfilter,e,tp,mg1,nil,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c9310011.op(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9310011.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,c9310011.rfilter,e,tp,mg1,nil,Card.GetLevel,"Greater")
	local tc=g:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
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
		local spos=0
		if tc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true,POS_FACEUP_DEFENSE) then spos=spos+POS_FACEUP_DEFENSE end
		if tc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true,POS_FACEDOWN_DEFENSE) then spos=spos+POS_FACEDOWN_DEFENSE end
		if spos~=0 then
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,spos)
			if tc:IsFacedown() then
			Duel.ConfirmCards(1-tp,tc) 
			end
		tc:CompleteProcedure()
		end
	end
end
function c9310011.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(9310011,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c9310011.indcon(e)
	local c=e:GetHandler()
	return (c:GetFlagEffect(9310011)~=0 or c:IsSummonType(SUMMON_TYPE_RITUAL)) and c:IsDefensePos()
end
function c9310011.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9310011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c9310011.filter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0x92c,0x3f91) and c:IsAbleToHand()
end
function c9310011.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		sg=g:Select(tp,1,1,nil)
		tc=sg:GetFirst()
		if tc:IsDefensePos() and tc:IsCanChangePosition() then
			if tc:IsCanTurnSet() and tc:IsFaceup() then
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
			elseif tc:IsFacedown() then
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE) end
		end
		if tc:IsAttackPos() and tc:IsCanChangePosition() then
			if tc:IsCanTurnSet() then
			Duel.ChangePosition(tc,Duel.SelectPosition(tp,tc,POS_FACEDOWN_DEFENSE+POS_FACEUP_DEFENSE))
			else
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE) end
		end
		local kg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9310011.filter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		if kg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9310011,0)) then
			Duel.BreakEffect()
			Duel.SendtoHand(kg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,kg)
		end
	end
end