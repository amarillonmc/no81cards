--fate·鈴鹿 御前 
function c9950096.initial_effect(c)
	 --link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c9950096.matfilter,2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950096.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
	--target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetCondition(c9950096.atcon)
	e2:SetValue(c9950096.atlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c9950096.atcon)
	e3:SetTarget(c9950096.tglimit)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--return to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950096,2))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCountLimit(1,9950096)
	e1:SetTarget(c9950096.thtg)
	e1:SetOperation(c9950096.thop)
	c:RegisterEffect(e1)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950096,1))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,99500960)
	e1:SetCondition(c9950096.discon)
	e1:SetCost(c9950096.discost)
	e1:SetTarget(c9950096.distg)
	e1:SetOperation(c9950096.disop)
	c:RegisterEffect(e1)
end
function c9950096.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950096,0))
end
function c9950096.matfilter(c)
	return (c:IsLinkType(TYPE_EFFECT) and c:IsLinkAttribute(ATTRIBUTE_WIND)) or(c:IsLinkType(TYPE_LINK) and c:IsLinkRace(RACE_WARRIOR))
end
function c9950096.filter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) or c:IsRace(RACE_WARRIOR)
end
function c9950096.atcon(e)
	return Duel.IsExistingMatchingCard(c9950096.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c9950096.atlimit(e,c)
	return c~=e:GetHandler()
end
function c9950096.tglimit(e,c)
	return c~=e:GetHandler()
end
function c9950096.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local d=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetAttacker()==c and d and d:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,d,1,0,0)
end
function c9950096.thop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d and d:IsRelateToBattle() then
		Duel.SendtoHand(d,nil,REASON_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950096,0))
	end
end
function c9950096.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c9950096.costfilter(c)
	return (c:IsAttribute(ATTRIBUTE_WIND) or c:IsRace(RACE_WARRIOR))and c:IsAbleToGraveAsCost()
end
function c9950096.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950096.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9950096.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9950096.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c9950096.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950096,0))
	end
end
