--幻煌龙 漩涡
function c98920425.initial_effect(c)
	c:SetSPSummonOnce(98920425)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_NORMAL),1,1)
	c:EnableReviveLimit()
	 --atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920425,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c98920425.atkcon1)
	e1:SetOperation(c98920425.atkop1)
	c:RegisterEffect(e1)
--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920425,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c98920425.srcon)
	e3:SetTarget(c98920425.srtg)
	e3:SetOperation(c98920425.srop)
	c:RegisterEffect(e3)
end
function c98920425.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c98920425.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local g=c:GetMaterial()
	local atk=g:GetSum(Card.GetBaseAttack)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetValue(atk)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e0)
	if c:IsRelateToEffect(e) then
	   Duel.BreakEffect()
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_ADD_TYPE)
	   e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	   e1:SetRange(LOCATION_MZONE)
	   e1:SetValue(TYPE_NORMAL)
	   c:RegisterEffect(e1)
	   local e2=e1:Clone()
	   e2:SetCode(EFFECT_REMOVE_TYPE)
	   e2:SetValue(TYPE_EFFECT)
	   c:RegisterEffect(e2)
	end
end
function c98920425.srcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c98920425.srfilter(c)
	return c:IsSetCard(0xfa) and c:IsAbleToHand()
end
function c98920425.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920425.srfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920425.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920425.srfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end