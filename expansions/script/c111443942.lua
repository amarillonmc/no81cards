--影依の廻転
function c111443942.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,111443942+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c111443942.target)
	e1:SetOperation(c111443942.operation)
	c:RegisterEffect(e1)
	--plus effect
	if not c111443942.global_check then
		c111443942.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c111443942.sdop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c111443942.filter(c)
	return c:IsSetCard(0x9d) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(111443942)
end
function c111443942.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c111443942.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c111443942.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,111443942,RESET_PHASE+PHASE_END,0,1)
	if Duel.IsExistingMatchingCard(c111443942.filter,tp,LOCATION_DECK,0,2,nil) then
		local sg=Duel.GetMatchingGroup(c111443942.filter,tp,LOCATION_DECK,0,nil)
		Duel.ConfirmCards(tp,sg)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c111443942.con)
	e1:SetOperation(c111443942.op)
	e1:SetLabelObject(e6)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EVENT_TO_HAND)
	Duel.RegisterEffect(e3,tp)
	local e4=e1:Clone()
	e4:SetCode(EVENT_TO_DECK)
	Duel.RegisterEffect(e4,tp)
	local e5=e1:Clone()
	e5:SetCode(EVENT_REMOVE)
	Duel.RegisterEffect(e5,tp)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVED)
	e6:SetOperation(c111443942.disop)
	e6:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e6,tp)
	local e7=e6:Clone()
	e7:SetCode(EVENT_CHAINING)
	Duel.RegisterEffect(e7,tp)
end

function c111443942.cfilter(c,tp)
	return c:GetPreviousControler()==tp
		and (c:IsPreviousLocation(LOCATION_DECK) or c:GetSummonLocation()==LOCATION_DECK
			or (c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK))
			or c:IsLocation(LOCATION_DECK)) and not c:IsReason(REASON_DRAW)
end
function c111443942.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c111443942.cfilter,1,nil,tp)
end
function c111443942.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if g:GetCount()<=1 then return end
	c:RegisterFlagEffect(111443942,RESET_PHASE+PHASE_END,0,1)
end

function c111443942.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if g:GetCount()<=1 then return end
	if c:GetFlagEffect(111443942)~=0 and Duel.IsExistingMatchingCard(c111443942.filter,tp,LOCATION_DECK,0,2,nil) then
		local sg=Duel.GetMatchingGroup(c111443942.filter,tp,LOCATION_DECK,0,nil)
		Duel.ConfirmCards(tp,sg)
		c:ResetFlagEffect(111443942)
	end
end

function c111443942.sdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetOwner()
	local g=Duel.GetMatchingGroup(c111443942.filter,c,LOCATION_DECK,LOCATION_DECK,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(111443942)==0 then
			local code=tc:GetOriginalCode()
			local ae=tc:GetActivateEffect()
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_ACTIVATE)
			e1:SetCode(ae:GetCode())
			e1:SetCategory(ae:GetCategory())
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+ae:GetProperty())
			e1:SetRange(LOCATION_DECK)
			e1:SetCountLimit(1,code+EFFECT_COUNT_CODE_OATH)
			e1:SetCondition(c111443942.sfcon)
			e1:SetTarget(c111443942.sftg)
			e1:SetOperation(c111443942.sfop)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			--activate cost
			local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_ACTIVATE_COST)
			e2:SetRange(LOCATION_DECK)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE)
			e2:SetTargetRange(LOCATION_DECK,0)
			e2:SetCost(c111443942.costchk)
			e2:SetTarget(c111443942.costtg)
			e2:SetOperation(c111443942.costop)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetLabel(111443942)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(111443942,RESET_EVENT+0x1fe0000,0,1)
		end
		tc=g:GetNext()
	end
end

--deck activate
function c111443942.sfcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,111443942)>0 and Duel.GetFlagEffect(tp,e:GetHandler():GetOriginalCode())==0
end
function c111443942.sftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ae=e:GetHandler():GetActivateEffect()
	local fcon=ae:GetCondition()
	local fcos=ae:GetCost()
	local ftg=ae:GetTarget()
	local c=e:GetHandler()
	if chk==0 then
		return (not fcon or fcon(e,tp,eg,ep,ev,re,r,rp))
			and (not fcos or fcos(e,tp,eg,ep,ev,re,r,rp,0))
			and (not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,0))
			and c:IsSetCard(0x9d) and c:IsType(TYPE_SPELL+TYPE_TRAP)
	end
	if fcos then
		fcos(e,tp,eg,ep,ev,re,r,rp,1)
	end
	if ftg then
		ftg(e,tp,eg,ep,ev,re,r,rp,1)
	end
	Duel.RegisterFlagEffect(tp,e:GetHandler():GetOriginalCode(),RESET_PHASE+PHASE_END,0,1)
end
function c111443942.sfop(e,tp,eg,ep,ev,re,r,rp)
	local ae=e:GetHandler():GetActivateEffect()
	local fop=ae:GetOperation()
	if fop then
		fop(e,tp,eg,ep,ev,re,r,rp)
	end
end

--activate field
function c111443942.costfilter(c)
	return c:IsSetCard(0x9d) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c111443942.costchk(e,te_or_c,tp)
	local tp=e:GetHandler():GetControler()
	return (Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c111443942.costfilter,tp,LOCATION_GRAVE,0,1,nil)) or not te_or_c:GetHandler():IsLocation(LOCATION_DECK)
end
function c111443942.costtg(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler():IsLocation(LOCATION_DECK) and te:GetHandler()==e:GetHandler()
end
function c111443942.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c111443942.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		local te=e:GetLabelObject()
		Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		c:CreateEffectRelation(te)
		local ev0=Duel.GetCurrentChain()+1
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetCountLimit(1)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
		e1:SetOperation(c111443942.rsop)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_CHAIN_NEGATED)
		Duel.RegisterEffect(e2,tp)
	end
end
function c111443942.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
	end
end

local re=Card.RegisterEffect
Card.RegisterEffect=function(c,e)
	if c111443942.filter(c) and c:IsType(TYPE_CONTINUOUS+TYPE_EQUIP+TYPE_FIELD) and not e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetLabel()~=111443942 then
		local tg=e:GetTarget()
		if not tg then tg=aux.TRUE end
		e:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then return tg(e,tp,eg,ep,ev,re,r,rp,0) and not c:IsStatus(STATUS_CHAINING) end tg(e,tp,eg,ep,ev,re,r,rp,1) end)
	end
	re(c,e)
end
