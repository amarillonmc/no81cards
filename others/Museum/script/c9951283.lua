--伊莉雅-Assassin形态
function c9951283.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xaba8),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),true)
--battle indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(1)
	e4:SetCondition(c9951283.actcon)
	c:RegisterEffect(e4)
 --remove
	local ea=Effect.CreateEffect(c)
	ea:SetDescription(aux.Stringid(9951283,0))
	ea:SetCategory(CATEGORY_REMOVE)
	ea:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	ea:SetCode(EVENT_BATTLE_START)
	ea:SetCountLimit(1)
	ea:SetTarget(c9951283.rmtg)
	ea:SetOperation(c9951283.rmop)
	c:RegisterEffect(ea)
--To hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9951283,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCondition(c9951283.thcon)
	e4:SetTarget(c9951283.thtg)
	e4:SetOperation(c9951283.thop)
	c:RegisterEffect(e4)
  --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951283.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951283.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951283,0))
end
function c9951283.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c9951283.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetBattleTarget()
	if chk==0 then return tc and tc:IsControler(1-tp) and tc:IsAbleToRemove(tp,POS_FACEDOWN) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function c9951283.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc:IsRelateToBattle() then
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951283,0))
end
function c9951283.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function c9951283.filter(c)
	return c:IsSetCard(0xaba8) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9951283.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9951283.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9951283.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c9951283.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9951283.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951283,0))
end
