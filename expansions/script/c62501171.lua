--团团圆圆 叠叠团子
function c62501171.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c62501171.mfilter,nil,3,3)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(c62501171.splimit)
	c:RegisterEffect(e0)
	--attack up-other
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xea1))
	e1:SetValue(c62501171.atkval)
	c:RegisterEffect(e1)
	--attack up-action
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,62501171)
	e2:SetCondition(c62501171.atkcon)
	e2:SetCost(c62501171.atkcost)
	e2:SetTarget(c62501171.atktg)
	e2:SetOperation(c62501171.atkop)
	c:RegisterEffect(e2)
	--tango remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(c62501171.rmop)
	c:RegisterEffect(e3)
end
function c62501171.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,1) or c:IsLink(1)
end
function c62501171.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.xyzlimit(e,se,sp,st) or se:GetHandler():IsSetCard(0xea1)
end
function c62501171.cfilter(c)
	return c:IsSetCard(0xea1) and c:IsFaceup()
end
function c62501171.atkval(e,c)
	return Duel.GetMatchingGroupCount(c62501171.cfilter,c:GetControler(),LOCATION_ONFIELD+LOCATION_REMOVED,0,nil)*100
end
function c62501171.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (Duel.GetTurnPlayer()==tp and ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
		or (Duel.GetTurnPlayer()==1-tp and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function c62501171.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c62501171.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501171.cfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c62501171.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c62501171.cfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(tc:GetAttack()*3)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c62501171.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
