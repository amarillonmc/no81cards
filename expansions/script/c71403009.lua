--美学魔术！
---@param c Card
if not c71403001 then dofile("expansions/script/c71403001.lua") end
function c71403009.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(yume.PPTLimitCost)
	c:RegisterEffect(e0)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLED)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(c71403009.op1)
	c:RegisterEffect(e1)
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1a:SetCode(EVENT_DESTROYED)
	e1a:SetRange(LOCATION_SZONE)
	e1a:SetOperation(c71403009.op1a)
	c:RegisterEffect(e1a)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71403009,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_DECK)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c71403009.con2)
	e2:SetTarget(c71403009.tg2)
	e2:SetOperation(c71403009.op2)
	c:RegisterEffect(e2)
	yume.RegPPTSTGraveEffect(c,71403009)
	yume.PPTCounter()
end
function c71403009.op1(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local p=e:GetHandler():GetControler()
	if d==nil then return end
	local tc=nil
	if a:GetControler()==p and a:IsSetCard(0x715) and d:IsStatus(STATUS_BATTLE_DESTROYED) then tc=d
	elseif d:GetControler()==p and a:IsSetCard(0x715) and a:IsStatus(STATUS_BATTLE_DESTROYED) then tc=a end
	if not tc then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2)
end
function c71403009.op1a(e,tp,eg,ep,ev,re,r,rp)
	local reset_code=0
	if tc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) then
			tc:RegisterFlagEffect(76794549,RESET_EVENT+0x1f20000+RESET_PHASE+PHASE_END,0,1)
		elseif tc:IsLocation(LOCATION_EXTRA) then
			tc:RegisterFlagEffect(76794549,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
end
function c71403009.filter1a(c,tp,re,rp)
	if (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_EXTRA+LOCATION_REMOVED) and c:IsFaceup()) then
		local rc=nil
		if c:IsReason(REASON_BATTLE) then
			rc=c:GetReasonCard()
			return c:IsPreviousControler(1-tp)
				and not (rc:IsRelateToBattle() and rc:IsSetCard(0x715) and rc:IsControler(tp)
				or rc:IsStatus(STATUS_BATTLE_DESTROYED) and rc:IsPreviousSetCard(0x715) and rc:IsPreviousControler(tp))
		elseif c:IsReason(REASON_EFFECT) then
			rc=re:GetHandler()
			return c:IsPreviousControler(1-tp) and c:IsControler(1-tp)
				and rp~=tp and rc:IsSetCard(0x715)
		else
			return false
		end
	else
		return false
	end
end
function c71403009.op1a(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c71403009.filter1a,nil,tp,re,rp)
	if g:GetCount()==0 then return end
	local c=e:GetHandler()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1f20000)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1f20000)
		if tc:IsLocation(LOCATION_EXTRA) then
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		end
		tc:RegisterEffect(e1)
		tc:RegisterEffect(e2)
	end
end
function c71403009.filter2(c,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsPreviousLocation(LOCATION_EXTRA) and c:IsPreviousControler(tp)
end
function c71403009.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c71403009.filter2,1,nil,tp)
end
function c71403009.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c71403009.op2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end