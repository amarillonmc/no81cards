--幻旅传说·沉溺
--21.04.10
local m=11451407
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Release
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.recon)
	e3:SetOperation(cm.reop)
	c:RegisterEffect(e3)
	--maintain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(cm.mtcon)
	e4:SetOperation(cm.mtop)
	c:RegisterEffect(e4)
end
cm.traveler_saga=true
function cm.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.desfilter,1,nil,tp)
end
function cm.desfilter(c,tp)
	return c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==1-tp
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLPCost(tp,1000) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.PayLPCost(tp,1000)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
	re:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
end
function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	local seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_SEQUENCE)
	local rc=re:GetHandler()
	return ep~=tp and e:GetHandler():GetFlagEffect(m)~=0 and re:GetHandler():GetFlagEffect(m)~=0 and re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE and seq<5 and rc:IsLocation(LOCATION_MZONE)
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local p=rc:GetControler()
	local seq1=e:GetHandler():GetSequence()
	local seq2=rc:GetSequence()
	if seq1>4 or seq2>4 then return end
	if p~=tp then seq1=4-seq1 end
	if (seq1>seq2 and Duel.CheckLocation(p,LOCATION_MZONE,seq2+1)) then
		Duel.MoveSequence(rc,seq2+1)
	elseif (seq1<seq2 and Duel.CheckLocation(p,LOCATION_MZONE,seq2-1)) then
		Duel.MoveSequence(rc,seq2-1)
	else
		Duel.Hint(HINT_CARD,0,m)
		Duel.Destroy(rc,REASON_EFFECT)
	end
end