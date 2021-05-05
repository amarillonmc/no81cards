--深夜特侦 上神
local m=40009223
local c40009223=_G["c"..m]
function c40009223.initial_effect(c)
	c:SetUniqueOnField(1,0,m)   
	--repeat effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009223,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c40009223.cpcon)
	e1:SetTarget(c40009223.cptg)
	e1:SetOperation(c40009223.cpop)
	c:RegisterEffect(e1)	
end
function c40009223.cpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local loc,seq,p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE,CHAININFO_TRIGGERING_CONTROLER)
	local col=0
	if loc&LOCATION_MZONE~=0 then
		col=aux.MZoneSequence(seq)
	elseif loc&LOCATION_SZONE~=0 then
		if seq>4 then return false end
		col=aux.SZoneSequence(seq)
	else
		return false
	end
	if p==1-tp then col=4-col end
	return aux.GetColumn(c,tp)==col and rc:IsOriginalSetCard(0x1f1d) and not rc:IsCode(m) and p==tp
end
function c40009223.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=re:GetTarget()
	if chk==0 then return not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) end
	e:SetProperty(re:GetProperty())
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	Duel.ClearOperationInfo(0)
end
function c40009223.cpop(e,tp,eg,ep,ev,re,r,rp)
	local op=re:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(4)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(1000)
		c:RegisterEffect(e2)   
		local e3=e2:Clone()
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e3)			
	end
end
