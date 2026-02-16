--马到成功，功？
function c75040031.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(75040031,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c75040031.handcon)
	c:RegisterEffect(e0)
    --SearchCard
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(c75040031.target)
	e1:SetOperation(c75040031.activate)
	c:RegisterEffect(e1)
    --battle destroyed
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75040031,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetCost(aux.bfgcost)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c75040031.condition)
	e2:SetTarget(c75040031.target2)
	e2:SetOperation(c75040031.operation2)
	c:RegisterEffect(e2)
end
-- 0
function c75040031.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_WYRM)
end
function c75040031.handcon(e)
	return Duel.IsExistingMatchingCard(c75040031.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
-- 1
function c75040031.filter1(c)
	return c:IsDiscardable(REASON_EFFECT)
end
function c75040031.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsDefense(1800) and c:IsRace(RACE_WYRM) and c:IsAbleToHand()
end
function c75040031.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c75040031.filter1,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c75040031.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75040031.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,c75040031.filter1,1,1,REASON_EFFECT+REASON_DISCARD,nil)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c75040031.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c75040031.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c75040031.splimit(e,c)
	return not c:IsRace(RACE_WYRM)
end
-- 2
function c75040031.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c75040031.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,800)
end
function c75040031.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,2026,REASON_EFFECT)
	Duel.Recover(1-tp,2026,REASON_EFFECT)
end
