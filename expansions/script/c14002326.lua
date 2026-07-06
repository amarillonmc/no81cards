--诉说之创星辉 夜刀浦罗
local m=14002326
local cm=_G["c"..m]
cm.named_with_Urara=1
function cm.initial_effect(c)
	--Synchro
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,cm.tuner_filter,nil,nil,cm.synmatfilter,1,99)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.stsyncon)
	e0:SetTarget(cm.stsyntg)
	e0:SetOperation(cm.stsynop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	--atkchange
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.atkcon)
	e1:SetTarget(cm.atktg)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(2,m)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(2,m)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.Hastur(c)
	local m_code=_G["c"..c:GetCode()]
	return m_code and m_code.named_with_Hastur
end
function cm.tuner_filter(c)
	return cm.Hastur(c) and c:IsType(TYPE_TUNER)
end
function cm.synmatfilter(c)
	return c:IsType(TYPE_TOKEN) or c:IsType(TYPE_SYNCHRO)
end
function cm.stsynfilter(c,syncard)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard) and cm.synmatfilter(c)
end
function cm.stsyngoal(g,target_lv,syncard)
	return g:GetSum(Card.GetSynchroLevel,syncard)==target_lv
end
function cm.stsyncon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local lv=c:GetLevel()
	local remain=lv-1
	if remain<=0 then return false end
	if not Duel.IsCanRemoveCounter(tp,1,1,0x1402,1,REASON_MATERIAL) then return false end
	local mg=Duel.GetMatchingGroup(cm.stsynfilter,tp,LOCATION_MZONE,0,nil,c)
	return mg:CheckSubGroup(cm.stsyngoal,1,99,remain,c)
end
function cm.stsyntg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local lv=c:GetLevel()
	local remain=lv-1
	local mg=Duel.GetMatchingGroup(cm.stsynfilter,tp,LOCATION_MZONE,0,nil,c)
	local cancel=Duel.IsSummonCancelable()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local tg=mg:SelectSubGroup(tp,cm.stsyngoal,cancel,1,99,remain,c)
	if tg then
		tg:KeepAlive()
		e:SetLabelObject(tg)
		return true
	else
		return false
	end
end
function cm.stsynop(e,tp,eg,ep,ev,re,r,rp,c)
	local tg=e:GetLabelObject()
	if not tg then return end
	Duel.RemoveCounter(tp,1,1,0x1402,1,REASON_MATERIAL+REASON_SYNCHRO)
	c:SetMaterial(tg)
	Duel.SendtoGrave(tg,REASON_MATERIAL+REASON_SYNCHRO)
	tg:DeleteGroup()
end
function cm.atkcon(e)
	local c=e:GetHandler()
	if not Duel.GetAttacker() then return end
	return c==Duel.GetAttacker() or c==Duel.GetAttackTarget()
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g=Duel.GetMatchingGroup(Card.IsType,0,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_TOKEN)
		if g:GetCount()==0 then return false end
		local g1,atk=g:GetMaxGroup(Card.GetBaseAttack)
		return not c:IsAttack(atk)
	end
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsType,0,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_TOKEN)
	if g:GetCount()==0 then return end
	local g1,atk=g:GetMaxGroup(Card.GetBaseAttack)
	if c:IsFaceup() and atk>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(atk)
		c:RegisterEffect(e1)
	end
end
function cm.ctfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x1402,1)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) and Duel.IsExistingMatchingCard(cm.ctfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		local cg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
		local valid_cg=cg:Filter(Card.IsCanAddCounter,nil,0x1402,1)
		if #valid_cg>0 then
			for cc in aux.Next(valid_cg) do
				cc:AddCounter(0x1402,1)
			end
		end
	end
end
function cm.relfilter_eff(c)
	return c:IsType(TYPE_TOKEN) and c:IsReleasableByEffect()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g=Duel.GetMatchingGroup(cm.relfilter_eff,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		return g:IsExists(function(tc) return Duel.GetMZoneCount(tp,tc)>0 end, 1, nil)
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.relfilter_eff,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local rg=g:Filter(function(tc) return Duel.GetMZoneCount(tp,tc)>0 end, nil)
	if #rg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=rg:Select(tp,1,1,nil):GetFirst()
	if tc and Duel.Release(tc,REASON_EFFECT)>0 then
		if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
			local sg=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,nil)
			if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sc=sg:Select(tp,1,1,nil):GetFirst()
				Duel.XyzSummon(tp,sc,nil)
			end
		end
	end
end