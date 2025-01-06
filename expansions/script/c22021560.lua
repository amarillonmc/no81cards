--人理之基 弗拉德三世
function c22021560.initial_effect(c)
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c22021560.sprcon)
	e1:SetOperation(c22021560.sprop)
	c:RegisterEffect(e1)
	--to szone
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22021560,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22021560)
	e2:SetCondition(c22021560.rmcon)
	e2:SetTarget(c22021560.rmtg)
	e2:SetOperation(c22021560.rmop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22021560,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1,22021561)
	e3:SetTarget(c22021560.damtg)
	e3:SetOperation(c22021560.damop)
	c:RegisterEffect(e3)
	--to szone ere
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22021560,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,22021560)
	e4:SetCondition(c22021560.rmcon1)
	e4:SetCost(c22021560.erecost)
	e4:SetTarget(c22021560.rmtg)
	e4:SetOperation(c22021560.rmop)
	c:RegisterEffect(e4)
	--damage ere
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22021560,3))
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCountLimit(1,22021561)
	e5:SetCondition(c22021560.erecon)
	e5:SetCost(c22021560.erecost)
	e5:SetTarget(c22021560.damtg)
	e5:SetOperation(c22021560.damop)
	c:RegisterEffect(e5)
end
function c22021560.sprfilter(c)
	return c:IsSetCard(0xff1) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c22021560.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22021560.sprfilter,tp,LOCATION_GRAVE,0,3,nil)
end
function c22021560.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c22021560.sprfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c22021560.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function c22021560.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return rc:IsRelateToEffect(re) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and not rc:IsLocation(LOCATION_SZONE) end
end
function c22021560.rmop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and rc:IsRelateToEffect(e) and not rc:IsImmuneToEffect(e) and Duel.SelectOption(tp,aux.Stringid(22021560,4)) then
		Duel.MoveToField(rc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(rc)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		rc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(rc)
		e2:SetCode(EFFECT_CHANGE_CODE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e2:SetValue(22021580)
		rc:RegisterEffect(e2)
	end
end
function c22021560.filter(c)
	return c:IsCode(22021580) and c:IsFaceup()
end
function c22021560.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=Duel.GetMatchingGroupCount(c22021560.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*500
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c22021560.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dam=Duel.GetMatchingGroupCount(c22021560.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*500
	Duel.SelectOption(tp,aux.Stringid(22021560,5))
	Duel.Damage(p,dam,REASON_EFFECT)
end
function c22021560.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c22021560.rmcon1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22021560.erecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end