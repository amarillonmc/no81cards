local m=11638008
local cm=_G["c"..m]
cm.name="太古暗杀拳·茶道"
function cm.initial_effect(c)
	aux.AddCodeList(c,11638001)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.activate1)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.activate2)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e3:SetTarget(cm.target3)
	e3:SetOperation(cm.activate3)
	c:RegisterEffect(e3)
end
function cm.filter1(c)
	return c:IsCode(11638001) and c:IsPosition(POS_FACEUP_ATTACK)
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter1,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local c1=Duel.GetFirstTarget()
	if c1:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
		local c2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
		if c2 and c1:IsControler(tp) and c1:IsPosition(POS_FACEUP_ATTACK) and not c2:IsImmuneToEffect(e) and c2:IsControler(1-tp) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
			e1:SetTargetRange(1,1)
			e1:SetReset(RESET_CHAIN)
			Duel.RegisterEffect(e1,tp)
			Duel.HintSelection(Group.FromCards(c2))
			Duel.CalculateDamage(c1,c2,true)
		end
	end
end
function cm.filter2(c)
	return c:IsCode(11638001) and c:IsFaceup()
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ph=Duel.GetCurrentPhase()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_MZONE,0,1,nil) and Duel.IsAbleToEnterBP() or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	--extra attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(m,4))
	e1:SetValue(cm.exatkval)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.BreakEffect()
		local tc=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
		local fid=c:GetFieldID()
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_BATTLE,0,1)
		tc:RegisterFlagEffect(m,RESET_PHASE+PHASE_BATTLE+RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
		e2:SetCountLimit(1)
		e2:SetLabel(fid)
		e2:SetLabelObject(tc)
		e2:SetCondition(cm.descon)
		e2:SetOperation(cm.desop)
		e2:SetReset(RESET_PHASE+PHASE_BATTLE)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.exatktg(e,c)
	return c:IsCode(11638001) and c:IsFaceup()
end
function cm.deffilter(c)
	return aux.IsCodeListed(c,11638001) and c:IsFaceup()
end
function cm.exatkval(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(cm.deffilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	return #g-1
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffectLabel(m)==e:GetLabel()
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_CARD,0,m)
	Duel.SendtoGrave(tc,REASON_RULE)
end
function cm.filter3(c)
	return not c:IsCode(11638001) or c:IsFacedown()
end
function cm.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ph=Duel.GetCurrentPhase()
	local b=(Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
		and not Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_MZONE,0,1,nil))
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter1,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_MZONE,0,1,nil) and (Duel.IsAbleToEnterBP() or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)) and b end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.noatkfilter(c)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.activate3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local c1=Duel.GetFirstTarget()
	if c1:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
		local c2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
		if c2 and c1:IsControler(tp) and c1:IsPosition(POS_FACEUP_ATTACK) and not c2:IsImmuneToEffect(e) and c2:IsControler(1-tp) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
			e1:SetTargetRange(1,1)
			e1:SetReset(RESET_CHAIN)
			Duel.RegisterEffect(e1,tp)
			Duel.HintSelection(Group.FromCards(c2))
			Duel.CalculateDamage(c1,c2,true)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	--extra attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(m,4))
	e1:SetValue(cm.exatkval)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	if Duel.IsExistingMatchingCard(cm.noatkfilter,tp,0,LOCATION_MZONE,1,c1) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.BreakEffect()
		local tc=Duel.SelectMatchingCard(tp,cm.noatkfilter,tp,0,LOCATION_MZONE,1,1,c1):GetFirst()
		local fid=c:GetFieldID()
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_BATTLE,0,1)
		tc:RegisterFlagEffect(m,RESET_PHASE+PHASE_BATTLE+RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
		e2:SetCountLimit(1)
		e2:SetLabel(fid)
		e2:SetLabelObject(tc)
		e2:SetCondition(cm.descon)
		e2:SetOperation(cm.desop)
		e2:SetReset(RESET_PHASE+PHASE_BATTLE)
		Duel.RegisterEffect(e2,tp)
	end
end