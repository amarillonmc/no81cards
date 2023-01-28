--牛头人的饕宴
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(cm.hand)
	e0:SetLabelObject(e1)
	c:RegisterEffect(e0)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.con1)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetCondition(cm.con2)
	e3:SetOperation(cm.desop1)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetOperation(cm.desop2)
	e5:SetLabelObject(e3)
	c:RegisterEffect(e5)
	local e7=e5:Clone()
	e7:SetCode(EVENT_CHAIN_NEGATED)
	c:RegisterEffect(e7)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_BATTLED)
	e6:SetOperation(cm.desop3)
	e6:SetLabelObject(e3)
	c:RegisterEffect(e6)
	--destroy sub
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(cm.reptg)
	e4:SetValue(cm.repval)
	c:RegisterEffect(e4)
	if not NTR_CHECK then
		NTR_CHECK=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BE_BATTLE_TARGET)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAINING)
		ge2:SetOperation(cm.checkop2)
		--Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_BECOME_TARGET)
		ge3:SetOperation(cm.checkop3)
		--ge3:SetLabelObject(ge2)
		Duel.RegisterEffect(ge3,0)
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_CHAIN_END)
		ge4:SetOperation(cm.checkop4)
		ge4:SetLabelObject(ge2)
		--Duel.RegisterEffect(ge4,0)
		local ge5=Effect.CreateEffect(c)
		ge5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge5:SetCode(EVENT_CHAIN_NEGATED)
		ge5:SetOperation(cm.checkop5)
		--Duel.RegisterEffect(ge5,0)
		local ge6=Effect.CreateEffect(c)
		ge6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge6:SetCode(EVENT_ADJUST)
		ge6:SetOperation(cm.checkop6)
		Duel.RegisterEffect(ge6,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	tc:RegisterFlagEffect(m-1,RESET_EVENT+RESETS_STANDARD,0,1)
end
function cm.checkop2(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or #g==0 then return end
	e:SetLabel(ev)
	local tg=g:Filter(Card.IsOnField,nil)
	if #tg>0 then
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(m-1,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	end
end
function cm.checkop3(e,tp,eg,ep,ev,re,r,rp)
	--local lab=e:GetLabelObject():GetLabel()
	--if lab~=ev-1 then return end
	local tg=eg:Filter(Card.IsOnField,nil)
	if #tg>0 then
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(m-1,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	end
end
function cm.checkop4(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(0)
end
function cm.checkop5(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or #g==0 then return end
	e:SetLabel(ev)
	local tg=g:Filter(Card.IsOnField,nil)
	if #tg>0 then
		for tc in aux.Next(tg) do
			tc:ResetFlagEffect(m-1)
		end
	end
end
function cm.checkop6(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(cm.ctgfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #tg>0 then
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(m-1,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	end
end
function cm.ctgfilter(c)
	return c:GetOwnerTargetCount()>0 and c:GetFlagEffect(m-1)==0
end
function cm.tgfilter(c,e)
	return c:IsCanBeEffectTarget(e) and c:GetFlagEffect(m-1)==0
end
function cm.hand(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,te)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		local g=Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),e)
	else
		local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	end
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
	end
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetCardTarget()
	return g and g:IsContains(Duel.GetAttackTarget())
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetCardTarget()
	return g and #Group.__band(g,eg)>0
end
function cm.spfilter(c,e,tp)
	return c:GetAttack()==1700 and c:GetDefense()==1000 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function cm.desop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_SZONE) and c:IsFaceup() then
		e:SetLabelObject(re)
		e:SetLabel(0)
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	end
end
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re==e:GetLabelObject():GetLabelObject() and c:GetFlagEffect(m)>0 then
		if Duel.GetCurrentPhase()==PHASE_DAMAGE and not Duel.IsDamageCalculated() then
			e:GetLabelObject():SetLabel(1)
		else
			if c:IsHasEffect(EFFECT_DISABLE) then return end
			if not c:IsDisabled() then cm.spop(e,tp,eg,ep,ev,re,r,rp) end
		end
	end
end
function cm.desop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local des=e:GetLabelObject():GetLabel()
	e:GetLabelObject():SetLabel(0)
	if c:IsHasEffect(EFFECT_DISABLE) then return end
	if des==1 and not c:IsDisabled() then
		cm.spop(e,tp,eg,ep,ev,re,r,rp)
	end
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	return true
end
function cm.repfilter(c,g)
	return g:IsContains(c) and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=e:GetHandler():GetCardTarget()
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,g) and c:IsCanTurnSet() and (not re or re:GetCode()~=EFFECT_SPSUMMON_PROC or Duel.GetLocationCountFromEx(re:GetHandlerPlayer(),re:GetHandlerPlayer(),Group.__sub(eg,g),re:GetHandler())>0) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		g:KeepAlive()
		e:SetLabelObject(g)
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		return true
	else return false end
end
function cm.repval(e,c)
	local g=e:GetLabelObject()
	local res=cm.repfilter(c,g)
	g:DeleteGroup()
	return res
end