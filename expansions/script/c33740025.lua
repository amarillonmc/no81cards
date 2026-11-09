--动物朋友 雪鸮
function c33740025.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetDescription(aux.Stringid(33740025,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33740025)
	e1:SetCost(c33740025.cost)
	e1:SetOperation(c33740025.operation)
	c:RegisterEffect(e1)
	--check
	if not c33740025.global_check then
		c33740025.global_check=true
		c33740025.effect_code={[0]={},[1]={}}
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetOperation(c33740025.clear)
		Duel.RegisterEffect(ge0,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c33740025.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c33740025.clear(e,tp,eg,ep,ev,re,r,rp)
	c33740025.effect_code={[0]={},[1]={}}
end
function c33740025.checkop(e,tp,eg,ep,ev,re,r,rp)
	local code=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE)
	local ct=c33740025.effect_code[rp][code] and c33740025.effect_code[rp][code]+1 or 1
	c33740025.effect_code[rp][code]=ct
end
function c33740025.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c33740025.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetTurnPlayer()==tp and 2 or 1
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_ACTIVATE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,1)
	e0:SetCondition(c33740025.accon)
	e0:SetValue(c33740025.aclimit)
	e0:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,ct)
	Duel.RegisterEffect(e0,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetOperation(c33740025.drop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c33740025.drop(e,tp,eg,ep,ev,re,r,rp)
	local code=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE)
	if (c33740025.effect_code[0][code] and c33740025.effect_code[0][code]>=2 or c33740025.effect_code[1][code] and c33740025.effect_code[1][code]>=2) then
		--Duel.ResetFlagEffect(tp,33740025)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c33740025.accon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c33740025.aclimit(e,re,tp)
	return c33740025.effect_code[tp][re:GetHandler():GetCode()] and c33740025.effect_code[tp][re:GetHandler():GetCode()]>=1
end
