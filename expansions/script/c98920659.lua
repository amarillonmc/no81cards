--狱火机·贝利亚
function c98920659.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFunRep(c,60551528,aux.FilterBoolFunction(Card.IsFusionSetCard,0xbb),1,63,true,true)
	 --remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c98920659.descon)
	e2:SetTarget(c98920659.destg)
	e2:SetOperation(c98920659.desop)
	c:RegisterEffect(e2)
	--atk down
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCondition(c98920659.acon)
	e1:SetValue(c98920659.atkval)
	c:RegisterEffect(e1)
	 --act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c98920659.acon)
	e3:SetTarget(c98920659.actfilter)
	c:RegisterEffect(e3)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920659,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(c98920659.thtg)
	e2:SetOperation(c98920659.thop)
	c:RegisterEffect(e2)
end
function c98920659.actfilter(e,c)
	return c:IsAttackBelow(e:GetHandler():GetAttack())
end
function c98920659.acon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c98920659.atkval(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_REMOVED,LOCATION_REMOVED)*-100
end
function c98920659.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c98920659.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	local ct=e:GetHandler():GetMaterialCount()
	if chk==0 then return ct>0
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_GRAVE,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c98920659.chlimit)
end
function c98920659.chlimit(e,ep,tp)
	return tp==ep
end
function c98920659.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c98920659.thfilter(c)
	return c:IsCode(91588074) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c98920659.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920659.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920659.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920659.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end