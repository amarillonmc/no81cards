--哈斯塔&夜刀浦罗 异海的姐妹
local m=14002331
local cm=_G["c"..m]
cm.named_with_Hastur=1
cm.named_with_Urara=1
function cm.initial_effect(c)
	--fusion
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),aux.FilterBoolFunction(Card.IsRace,RACE_REPTILE),true)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(cm.condition)
	e0:SetOperation(cm.regop)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
	--summon process
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.altcon)
	e2:SetTarget(cm.alttg)
	e2:SetOperation(cm.altop)
	e2:SetValue(SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	cm.selfsummon_effect=e3
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_SSET)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCountLimit(1)
	e4:SetCost(cm.setcost)
	e4:SetTarget(cm.settg)
	e4:SetOperation(cm.setop)
	c:RegisterEffect(e4)
end
function cm.Hastur(c)
	local m_code=_G["c"..c:GetCode()]
	return m_code and m_code.named_with_Hastur
end
function cm.Urara(c)
	local m_code=_G["c"..c:GetCode()]
	return m_code and m_code.named_with_Urara
end
function cm.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION and Duel.GetFlagEffect(sp,m)==0
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) or c:GetFlagEffect(m)>0
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.get_available_field(tp,code)
	if not UraraG_fieldcheck then return nil end
	local c=nil
	if code==14002341 and UraraG_fieldcheck.release then
		c=UraraG_fieldcheck.release[tp]
	elseif code==14002342 and UraraG_fieldcheck.counter then
		c=UraraG_fieldcheck.counter[tp]
	end
	if c and type(c)=="userdata" and c:IsHasEffect(code)~=nil and c:GetFlagEffect(code)==0 then
		return c
	end
	return nil
end
function cm.hastur_rel(c)
	return cm.Hastur(c) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function cm.urara_rel(c)
	return cm.Urara(c) and (c:IsReleasable() or c:IsLocation(LOCATION_HAND))
end
function cm.rel_check(c)
	return cm.hastur_rel(c) or cm.urara_rel(c)
end
function cm.alt_goal(g,tp,c)
	if #g~=2 then return false end
	local c1=g:GetFirst()
	local c2=g:GetNext()
	local v1 = cm.hastur_rel(c1) and cm.urara_rel(c2)
	local v2 = cm.hastur_rel(c2) and cm.urara_rel(c1)
	return (v1 or v2) and Duel.GetLocationCountFromEx(tp,tp,g,c)>0
end
function cm.deck_cost_filter(c)
	return cm.Urara(c) and c:IsAbleToGraveAsCost()
end
function cm.altcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetFlagEffect(tp,m)>0 then return false end
	local g=Duel.GetMatchingGroup(cm.rel_check,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	local b1=g:CheckSubGroup(cm.alt_goal,2,2,tp,c)
	local b2=cm.get_available_field(tp, 14002341)~=nil
		and Duel.IsExistingMatchingCard(cm.deck_cost_filter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		
	return b1 or b2
end
function cm.alttg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(cm.rel_check,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	local b1=g:CheckSubGroup(cm.alt_goal,2,2,tp,c)
	local fc=cm.get_available_field(tp, 14002341)
	local b2=(fc~=nil) and Duel.IsExistingMatchingCard(cm.deck_cost_filter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,0), aux.Stringid(14002341,1))
	elseif b1 then op=0
	else op=1 end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local cancel=Duel.IsSummonCancelable()
		local sg=g:SelectSubGroup(tp,cm.alt_goal,cancel,2,2,tp,c)
		if not sg then return false end
		sg:KeepAlive()
		e:SetLabelObject(sg)
		e:SetLabel(0)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectMatchingCard(tp,cm.deck_cost_filter,tp,LOCATION_DECK,0,1,1,nil)
		sg:KeepAlive()
		e:SetLabelObject(sg)
		e:SetLabel(1)
		fc:RegisterFlagEffect(14002341,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
	return true
end
function cm.altop(e,tp,eg,ep,ev,re,r,rp,c)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,0,1)
	local sg=e:GetLabelObject()
	if not sg then return end
	if e:GetLabel()==0 then Duel.Release(sg,REASON_SPSUMMON)
	else Duel.SendtoGrave(sg,REASON_SPSUMMON) end
	sg:DeleteGroup()
end
function cm.spfilter(c,e,tp)
	return cm.Hastur(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fc=cm.get_available_field(tp, 14002342)
	local has_counter=Duel.IsCanRemoveCounter(tp,1,1,0x1402,1,REASON_COST)
	if chk==0 then return fc~=nil or has_counter end
	if fc and (not has_counter or Duel.SelectYesNo(tp,aux.Stringid(14002341,0))) then
		fc:RegisterFlagEffect(14002342,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	else
		Duel.RemoveCounter(tp,1,1,0x1402,1,REASON_COST)
	end
end
function cm.setfilter(c)
	return cm.Hastur(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,3))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		if tc:IsType(TYPE_QUICKPLAY) then
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		end
		if tc:IsType(TYPE_TRAP) then
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		end
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end