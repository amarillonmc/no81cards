--光 辉 已 朽 的 世 柩
local m=22348389
local cm=_G["c"..m]
function cm.initial_effect(c)
	--adjust
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(c22348389.adjustop)
	c:RegisterEffect(e1)
	--send replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c22348389.srtg)
	e2:SetValue(aux.FALSE)
	c:RegisterEffect(e2)
	--des
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_CUSTOM+22348389)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c22348389.destg)
	e3:SetOperation(c22348389.desop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c22348389.desreptg)
	e4:SetValue(c22348389.desrepval)
	e4:SetOperation(c22348389.desrepop)
	c:RegisterEffect(e4)
	if not c22348389.global_check then
		c22348389.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c22348389.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c22348389.repfilter(c,tp)
	return c:IsOnField() and c:IsControler(tp) and (c:IsFacedown() or c:IsSetCard(0x370b))
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c22348389.reefilter(c)
	return c:IsSetCard(0x370b) and c:IsAbleToRemove()
end
function c22348389.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c22348389.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c22348389.reefilter,tp,LOCATION_DECK,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=Duel.SelectMatchingCard(tp,c22348389.reefilter,tp,LOCATION_DECK,0,1,1,nil,e):GetFirst()
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c22348389.desrepval(e,c)
	return c22348389.repfilter(c,e:GetHandlerPlayer())
end
function c22348389.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,22348389)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end

function c22348389.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c22348389.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end

function c22348389.srepfilter(c,e,tp)
	return e:GetHandler():GetColumnGroup():IsContains(c) and c:IsOnField() and c:GetDestination()~=LOCATION_REMOVED
end
function c22348389.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return eg:IsExists(c22348389.srepfilter,1,nil,e,tp) end
	local g=eg:Filter(c22348389.srepfilter,nil,e,tp)
	if aux.TRUE then
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(LOCATION_REMOVED)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(22348389,RESET_EVENT+0x1660000+RESET_PHASE+PHASE_END,0,1)
			tc=g:GetNext()
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetCountLimit(1)
		e1:SetCondition(c22348389.rscon)
		e1:SetOperation(c22348389.rsop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		return true
	else return false end
end
function c22348389.rsfilter(c)
	return c:GetFlagEffect(22348389)~=0
end
function c22348389.rscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348389.rsfilter,1,nil)
end
function c22348389.rsop(e,tp,eg,ep,ev,re,r,rp)
	local cp=e:GetHandlerPlayer()
	Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+22348389,e,0,cp,0,0)
end
function c22348389.filter1(c)
	return c:IsOriginalCodeRule(22348389) and c:IsFacedown() and c:GetColumnGroup():IsExists(Card.IsControler,1,nil,1-c:GetControler())
end
function c22348389.checkop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g1=Duel.GetMatchingGroup(c22348389.filter1,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
		Duel.ChangePosition(g1,POS_FACEUP)
end
function c22348389.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local c=e:GetHandler()
	if not c:GetColumnGroup():IsExists(Card.IsControler,1,nil,1-tp) and c:IsFaceup() and c:IsCanTurnSet() then
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
