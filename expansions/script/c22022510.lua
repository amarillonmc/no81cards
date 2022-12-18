--人理之基 楚霸王
function c22022510.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xff1),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--atk 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22022510,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetTarget(c22022510.atktg)
	e1:SetOperation(c22022510.atkop)
	c:RegisterEffect(e1)
	--extra attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22022510,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(c22022510.atcon)
	e2:SetCost(c22022510.atcost)
	e2:SetOperation(c22022510.atop)
	c:RegisterEffect(e2)
	--disable and atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c22022510.adcon)
	e3:SetTarget(c22022510.adtg)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_SET_ATTACK_FINAL)
	e5:SetValue(0)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e6:SetValue(0)
	c:RegisterEffect(e6)
end
function c22022510.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22022510.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c22022510.adcon(e)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and c:GetBattleTarget()
		and (Duel.GetCurrentPhase()==PHASE_DAMAGE or Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL)
end
function c22022510.adtg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end
function c22022510.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and aux.bdcon(e,tp,eg,ep,ev,re,r,rp)
		and e:GetHandler():IsChainAttackable(0)
end
function c22022510.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c22022510.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end