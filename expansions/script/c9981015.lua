--赤口大人-诹访子
function c9981015.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5bc1),aux.NonTuner(Card.IsAttribute,ATTRIBUTE_WATER),1)
	c:EnableReviveLimit()
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981015,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9981015.condition)
	e1:SetTarget(c9981015.target)
	e1:SetOperation(c9981015.operation)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981015,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,9981015)
	e2:SetCondition(c9981015.drcon)
	e2:SetTarget(c9981015.drtg)
	e2:SetOperation(c9981015.drop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c9981015.value)
	c:RegisterEffect(e3)
end
function c9981015.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c9981015.filter(c,ec)
	return c:IsSetCard(0x5bc1) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c9981015.target(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(c9981015.filter,tp,LOCATION_DECK,0,1,nil) end
   Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c9981015.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9981015.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c9981015.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c9981015.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9981015.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c9981015.atkfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5bc1)
end
function c9981015.value(e,c)
	return Duel.GetMatchingGroupCount(c9981015.atkfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_REMOVED,0,nil)*300
end