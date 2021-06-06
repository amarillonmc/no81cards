--流连于刹那芳华
function c10700751.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c10700751.condition)
	e1:SetTarget(c10700751.target)
	e1:SetOperation(c10700751.activate)
	c:RegisterEffect(e1)
	--Add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c10700751.acop1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_DECK)
	e3:SetOperation(c10700751.acop2)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetCondition(c10700751.atkcon)
	e4:SetTarget(c10700751.atktg)
	e4:SetValue(c10700751.atkval)
	c:RegisterEffect(e4)	
end
function c10700751.condition(e,tp,eg,ep,ev,re,r,rp)
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	return h1<h2
end
function c10700751.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10700751.activate(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	end
end
function c10700751.cfilter1(c)
	return c:IsAbleToHand()
end
function c10700751.acop1(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c10700751.cfilter1,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0x107c,ct,true)
	end
end
function c10700751.cfilter2(c)
	return c:IsAbleToDeck() or c:IsAbleToExtra()
end
function c10700751.acop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c10700751.cfilter1,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0x107c,ct,true)
	end
end
function c10700751.atkcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c10700751.atktg(e,c)
	return c:IsFaceup()
end
function c10700751.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x107c)*-100
end