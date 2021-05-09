--锖
function c71400038.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCondition(c71400038.condition)
	e1:SetTarget(c71400038.target)
	e1:SetOperation(c71400038.activate)
	e1:SetDescription(aux.Stringid(71400038,0))
	e1:SetCountLimit(1,71400038+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c71400038.cost)
	c:RegisterEffect(e1)
end
function c71400038.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=3000
end
function c71400038.filterc(c)
	return c:IsSetCard(0xd714) and c:IsAbleToRemoveAsCost()
end
function c71400038.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400038.filterc,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c71400038.filterc,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c71400038.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c71400038.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetCondition(c71400038.con1)
	e1:SetOperation(c71400038.op1)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(1,0)
	e2:SetValue(c71400038.aclimit2)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c71400038.tg3)
	e3:SetValue(1)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetValue(c71400038.filter4)
	Duel.RegisterEffect(e4,tp)
	local e4a=e1:Clone()
	e4a:SetCode(EFFECT_CANNOT_DISEFFECT)
	Duel.RegisterEffect(e4a,tp)
	Duel.RegisterFlagEffect(tp,71400038,0,0,0)
end
function c71400038.con1(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c71400038.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c71400038.aclimit2(e,re,rp)
	local rc=re:GetHandler()
	return rc:IsSetCard(0xd714) and not rc:IsImmuneToEffect(e)
end
function c71400038.tg3(e,c)
	return c:IsSetCard(0x714)
end
function c71400038.filter4(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	local tc=te:GetHandler()
	return p==tp and not (not ec:IsSetCard(0x714) and (ec:IsLocation(loc) or loc&LOCATION_ONFIELD==0) or not (ec:IsPreviousSetCard(0x714) or ec:IsLocation(loc)) and loc&LOCATION_ONFIELD~=0)
end