local m=15005702
local cm=_G["c"..m]
cm.name="德尔塔式骸神化机关-『矛盾』"
function cm.initial_effect(c)
	aux.AddCodeList(c,15005730)
	c:EnableReviveLimit()
	--flip
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_FLIP)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetOperation(cm.flipop)
	c:RegisterEffect(e0)
	--r sp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_STANDBY_PHASE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.clcon)
	e2:SetTarget(cm.cltg)
	e2:SetOperation(cm.clop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_FLIP)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.thcon)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end
function cm.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(15005702,RESET_EVENT+RESETS_STANDARD,0,1)
end
function cm.filter(c)
	return c:IsFaceupEx() and c:IsSetCard(0xcf3f)
end
function cm.flipfilter(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsCanTurnSet()
end
function cm.mustflipfilter(c,tp)
	local mg=Duel.GetRitualMaterial(tp)
	return c:IsLocation(LOCATION_MZONE) and not mg:IsContains(c)
end
function cm.mustreleasefilter(c,tp)
	local mg=Duel.GetRitualMaterial(tp)
	return c:IsLocation(LOCATION_MZONE) and mg:IsContains(c) and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.RitualGCheck(g,mustg,tp,tc,lv,Greater)
	local res=0
	if mustg then
		local tc=mustg:GetFirst()
		while tc do
			if g:IsContains(tc) then res=1 break end
			tc=mustg:GetNext()
		end
	end
	return aux.RitualCheck(g,tp,tc,lv,Greater) and (res==1 or Duel.GetMZoneCount(tp)>0)
end
function cm.SetGCheck(g,sg,mg,tp)
	local res=1
	if mg then
		local tc=mg:GetFirst()
		while tc do
			if not g:IsContains(tc) then res=0 end
			tc=mg:GetNext()
		end
	end
	return res==1 and (#g<#sg or Duel.GetMZoneCount(tp)>0)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local sg=Duel.GetMatchingGroup(cm.flipfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,nil,cm.filter,e,tp,mg,sg,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_REMOVED)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	local mg=Duel.GetRitualMaterial(tp)
	local sg=Duel.GetMatchingGroup(cm.flipfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil,cm.filter,e,tp,mg,sg,Card.GetLevel,"Greater")
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
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mustg=mg:Filter(cm.mustreleasefilter,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg:SelectSubGroup(tp,cm.RitualGCheck,true,1,tc:GetLevel(),mustg,tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat then goto cancel end
		tc:SetMaterial(mat)
		local mat2=mat:Filter(cm.flipfilter,nil)
		local mat3=mat:Filter(cm.mustflipfilter,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
		local mat4=mat2:SelectSubGroup(tp,cm.SetGCheck,false,0,#mat2,mat2,mat3,tp)
		mat:Sub(mat4)
		Duel.ReleaseRitualMaterial(mat)
		Duel.ChangePosition(mat4,POS_FACEDOWN_DEFENSE)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function cm.clcon(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) or e:GetHandler():GetFlagEffect(15005702)~=0)
end
function cm.clfilter(c)
	return c:IsFacedown() and c:IsControlerCanBeChanged()
end
function cm.cltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.clfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function cm.clop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.clfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local sg=g:Select(tp,1,1,nil)
	local tc=sg:GetFirst()
	Duel.HintSelection(sg)
	Duel.GetControl(tc,tp)
end
function cm.cfilter(c,tp)
	return c:IsControler(tp)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end