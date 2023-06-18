--无尽的重担 ～月童～
--Timeless Burden - Tsukiwarawa- || Fardello senza Tempo - Tsukiwarawa-
--Scripted by: XGlitchy30

xpcall(function() require("expansions/script/glitchylib_vsnemo") end,function() require("script/glitchylib_vsnemo") end)

local s,id,o=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	c:EnableCounterPermit(0x46d)
	--[[If this is your first turn of the Duel, you can activate this card from your hand.]]
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(s.handcon)
	c:RegisterEffect(e0)
	--[[When this card is activated: You lose 2000 LP, also until the End Phase of your opponent's next turn, all damage you would take becomes 0.]]
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--[[Cannot be destroyed by other card effects.]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	--[[Once per turn, during your Main Phase: You can place 1 counter on this card, and if you do, draw cards equal to the number of counters on this card (if any).]]
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_COUNTER|CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,RELEVANT_TIMINGS)
	e3:SetCondition(aux.MainPhaseCond(0))
	e3:SetTarget(s.cttg)
	e3:SetOperation(s.ctop)
	c:RegisterEffect(e3)
	--[[During the Standby Phase: You take damage equal to the number of counters on this card x 400.]]
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,4))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(s.damtg)
	e4:SetOperation(s.damop)
	c:RegisterEffect(e4)
	--[[If you have 6 or more cards in your hand, destroy this card.]]
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_SELF_DESTROY)
	e5:SetCondition(s.descon)
	c:RegisterEffect(e5)
	--[[If this card leaves the field: You lose LP equal to the number of counters that were on it x 2000.]]
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCode(EVENT_LEAVE_FIELD_P)
	e6:SetOperation(s.regop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,5))
	e7:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_LEAVE_FIELD)
	e7:SetLabelObject(e6)
	e7:SetCondition(s.lpcon)
	e7:SetOperation(s.lpop)
	c:RegisterEffect(e7)
	if not s.global_check then
		s.global_check=true
		s[0]=0
		s[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START|PHASE_DRAW)
		ge1:SetCountLimit(1,id)
		ge1:SetOperation(s.regturn)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_PHASE_START|PHASE_STANDBY)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_PHASE_START|PHASE_MAIN1)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge1:Clone()
		ge4:SetCode(EVENT_PHASE_START|PHASE_BATTLE_START)
		Duel.RegisterEffect(ge4,0)
		local ge5=ge1:Clone()
		ge5:SetCode(EVENT_PHASE_START|PHASE_MAIN2)
		Duel.RegisterEffect(ge5,0)
		local ge6=ge1:Clone()
		ge6:SetCode(EVENT_PHASE_START|PHASE_END)
		Duel.RegisterEffect(ge6,0)
	end
end
function s.regturn(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	s[p]=s[p]+1
end

--E0
function s.handcon(e)
	return s[e:GetHandlerPlayer()]==1
end

--E1
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsSpellTrapOnField,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.LoseLP(tp,2000)
	local c=e:GetHandler()
	local rct = (Duel.GetTurnPlayer()==tp and 1 or 2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT|EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE|PHASE_END|RESET_TURN_OPPO,rct)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE|PHASE_END|RESET_TURN_OPPO,rct)
	Duel.RegisterEffect(e2,tp)
end

--E2
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

--E3
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x46d)+1
	if chk==0 then return c:IsCanAddCounter(0x46d,1) and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x46d)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToChain() and c:IsFaceup() and c:AddCounter(0x46d,1)) then return end
	local ct=c:GetCounter(0x46d)
	if ct>0 then
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end

--E4
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetHandler():GetCounter(0x46d)
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,ct*400)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local ct=math.max(0,c:GetCounter(0x46d))
		Duel.Damage(p,ct*400,REASON_EFFECT)
	end
end

--E5
function s.descon(e)
	return Duel.GetHandCount(e:GetHandlerPlayer())>=116
end

--E6 and E7
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetCounter(0x46d)
	e:SetLabel(ct)
end
function s.lpcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	e:SetLabel(ct)
	return ct>0
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.LoseLP(tp,e:GetLabel()*2000)
end