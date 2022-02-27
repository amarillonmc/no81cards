--圣殿剑骑 威廉·马歇尔
function c33200627.initial_effect(c)
	c:EnableReviveLimit()
	--ritual summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200627,0))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,33200627)
	e1:SetCondition(c33200627.spcon)
	e1:SetTarget(c33200627.sptg)
	e1:SetOperation(c33200627.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200627,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,33200628)
	e2:SetTarget(c33200627.atktg)
	e2:SetOperation(c33200627.atkop)
	c:RegisterEffect(e2)
end

--e1
function c33200627.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c33200627.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk))
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true,POS_FACEUP) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lv=level_function(c)
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,lv-2,greater_or_equal)
	local res=mg:CheckSubGroup(aux.RitualCheck,1,lv-2,tp,c,lv-2,greater_or_equal)
	aux.GCheckAdditional=nil
	return res
end
function c33200627.rfilter(c,e,tp)
	return c:IsSetCard(0x5329)
end
function c33200627.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetRitualMaterial(tp)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200627.RitualUltimateFilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,c33200627.rfilter,e,tp,mg,nil,Card.GetLevel,"Equal") end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c33200627.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c33200627.RitualUltimateFilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,c33200627.rfilter,e,tp,mg,nil,Card.GetLevel,"Equal")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if sg then
			mg:Merge(sg)
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel()-2,"Equal")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel()-2,tp,tc,tc:GetLevel()-2,"Equal")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

--e2
function c33200627.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5329) and c:IsLevelAbove(0)
end
function c33200627.atkfilter2(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c33200627.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c33200627.atkfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c33200627.atkfilter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g1=Duel.SelectTarget(tp,c33200627.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g1,1,0,0)
end
function c33200627.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFirstTarget()
	if tc1:IsFaceup() and tc1:IsLevelAbove(0) and tc1:IsRelateToEffect(e) and Duel.IsExistingTarget(c33200627.atkfilter2,tp,0,LOCATION_MZONE,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
		local g2=Duel.SelectMatchingCard(tp,c33200627.atkfilter2,tp,0,LOCATION_MZONE,1,1,nil)
		local tc2=g2:GetFirst()
		local atk=tc1:GetLevel()*-100
		local atk1=tc2:GetAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(atk)
		tc2:RegisterEffect(e1)
		local atk2=tc2:GetAttack()
		local atk3=atk1-atk2
		if atk3>0 then 
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e2:SetValue(atk3)
			tc1:RegisterEffect(e2)
		end
	end
end