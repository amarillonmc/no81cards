--CiNo.54 雄心斗士 狮魄
function c79029533.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,5)
	c:EnableReviveLimit()
	--battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--2nd battle 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,79029533)
	e3:SetCost(c79029533.cost)
	e3:SetTarget(c79029533.tg)
	e3:SetOperation(c79029533.op)
	c:RegisterEffect(e3)	
end
c79029533.xyz_number=54
function c79029533.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029533.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()==PHASE_MAIN2 end
end
function c79029533.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
	Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,2)
	Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,2)
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_EP)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN)
	Duel.RegisterEffect(e2,tp)
end



