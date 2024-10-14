--净天地
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60010252)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(cm.desreptg)
	e2:SetValue(cm.desrepval)
	e2:SetOperation(cm.desrepop)
	c:RegisterEffect(e2)
	--spsm
	local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(m,2))
	e21:SetCategory(CATEGORY_DEFCHANGE+CATEGORY_RECOVER)
	e21:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e21:SetCode(EVENT_SUMMON_SUCCESS)
	e21:SetRange(LOCATION_SZONE)
	e21:SetTarget(cm.tg1)
	e21:SetOperation(cm.op1)
	c:RegisterEffect(e21)
	local e3=e21:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.condition)
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.activate)
	c:RegisterEffect(e4)
	--fusion
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW+CATEGORY_DESTROY+CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetOperation(cm.operationx)
	c:RegisterEffect(e2)
end
function cm.repfilter(c,card)
	return c==card and c:IsOnField()
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and c:IsFaceup()
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,c)
		and c:GetFlagEffect(m)<8 end
	return Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,0))
end
function cm.desrepval(e,c)
	return e:GetHandler()
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,6+e:GetHandler():GetFlagEffect(m)))
	Duel.Hint(HINT_CARD,0,m)
end

function cm.fil1(c,tp)
	return c:IsSummonPlayer(tp) and c:IsRace(RACE_ILLUSION) and c:IsFaceup()
end
--
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.fil1,1,nil,tp) and e:GetHandler():GetFlagEffect(m)<8 end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,6+e:GetHandler():GetFlagEffect(m)))
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.fil1,nil,tp)
	for c in aux.Next(g) do
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetValue(cm.efilter)
		c:RegisterEffect(e3)
	end
	if Duel.IsExistingMatchingCard(cm.fil2,tp,LOCATION_MZONE,0,1,nil) then
		local sg=Duel.GetMatchingGroup(cm.fil3,tp,LOCATION_MZONE,0,nil)
		for tc in aux.Next(sg) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(1200)
			tc:RegisterEffect(e1)
		end
		Duel.Recover(tp,1200,REASON_EFFECT)
	end
end

function cm.fil2(c)
	return c:IsCode(60010252) and c:IsFaceup()
end
function cm.fil3(c)
	return c:IsRace(RACE_ILLUSION) and c:IsFaceup()
end
function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end

function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)>=8000
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and e:GetHandler():GetFlagEffect(m)<8 end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,6+e:GetHandler():GetFlagEffect(m)))
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.operationx(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsAbleToHand() then return end
	if Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(cm.fil4,tp,LOCATION_SZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		if Duel.Draw(tp,1,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(cm.fil4,tp,LOCATION_SZONE,0,1,nil) then
			local g=Duel.GetMatchingGroup(cm.fil4,tp,LOCATION_SZONE,0,nil):Select(tp,1,1,nil)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
