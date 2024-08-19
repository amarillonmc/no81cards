--奥法博览厅
function c60010100.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(60010100,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c60010100.handcon)
	c:RegisterEffect(e0)	
	--activate
	local e1=Effect.CreateEffect(c)
	--e1:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1,60010100+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c60010100.cfmop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60010100,0))
	--e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	--e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c60010100.condition)
	--e2:SetTarget(c60010100.target)
	e2:SetOperation(c60010100.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	if not c60010100.global_check then
		c60010100.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c60010100.spcheckop)
		Duel.RegisterEffect(ge1,0)
	end 
end
function c60010100.spcheckop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if tc:IsSummonPlayer(0) and tc:IsSummonType(SUMMON_TYPE_RITUAL) and tc:IsSetCard(0x634) then p1=true else p2=true end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,60010100,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,60010100,RESET_PHASE+PHASE_END,0,1) end
end
function c60010100.handcon(e)
	return Duel.GetFlagEffect(tp,60010100)~=0
end
--
function c60010100.cfmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=3 then return end
	if Duel.ConfirmDecktop(tp,3)~=0 then
		local g=Duel.GetDecktopGroup(tp,3)
		if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then
			e:GetHandler():RegisterFlagEffect(60010095,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60010095,2))
		end
		if g:IsExists(Card.IsType,1,nil,TYPE_SPELL) then
			e:GetHandler():RegisterFlagEffect(60010096,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60010095,3))
		end
		if g:IsExists(Card.IsType,1,nil,TYPE_TRAP) then
			e:GetHandler():RegisterFlagEffect(60010097,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60010095,4))
		end
	end
end
--
function c60010100.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x634)
end
function c60010100.condition(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c60010100.cfilter,1,nil)
end
function c60010100.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	while tc do
		if Card.GetFlagEffect(c,60010095)~=0 then
			e:GetHandler():RegisterFlagEffect(60010095,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60010095,2)) 
		end
		if Card.GetFlagEffect(c,60010096)~=0 then
			e:GetHandler():RegisterFlagEffect(60010096,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60010095,2)) 
		end
		if Card.GetFlagEffect(c,60010097)~=0 then
			e:GetHandler():RegisterFlagEffect(60010097,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60010095,2)) 
		end
		tc=eg:GetNext()
	end
end


