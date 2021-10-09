--Dark Mephisto 
function c9950707.initial_effect(c)
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
	e1:SetCondition(c9950707.sprcon)
	e1:SetOperation(c9950707.sprop)
	c:RegisterEffect(e1)
 --todeck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950707,0))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c9950707.tdtg)
	e3:SetOperation(c9950707.tdop)
	c:RegisterEffect(e3)
 --damage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9950707,2))
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e5:SetCode(EVENT_CHANGE_POS)
	e5:SetCountLimit(1,99507070)
	e5:SetCondition(c9950707.damcon)
	e5:SetTarget(c9950707.damtg)
	e5:SetOperation(c9950707.damop)
	c:RegisterEffect(e5)
 --spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950707,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9950707)
	e2:SetTarget(c9950707.thtg)
	e2:SetOperation(c9950707.thop)
	c:RegisterEffect(e2)
--spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950707.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950707.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950707,0))
end
function c9950707.sprfilter(c)
	return c:IsSetCard(0x3bd3) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c9950707.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9950707.sprfilter,tp,LOCATION_GRAVE,0,2,nil)
end
function c9950707.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9950707.sprfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9950707.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c9950707.rfilter(c)
	return c:IsLocation(LOCATION_DECK+LOCATION_EXTRA) and c:IsAttribute(ATTRIBUTE_DARK) and bit.band(c:GetPreviousPosition(),POS_FACEUP)~=0
end
function c9950707.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local rt=Duel.GetOperatedGroup():FilterCount(c9950707.rfilter,nil)
	if rt>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(rt*1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c9950707.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3bd3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9950707.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED+LOCATION_GRAVE) and c9950707.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c9950707.filter,tp,LOCATION_REMOVED,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c9950707.filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,2,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c9950707.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c9950707.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK) and e:GetHandler():IsPreviousPosition(POS_FACEUP_DEFENSE)
end
function c9950707.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(3000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,3000)
end
function c9950707.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
