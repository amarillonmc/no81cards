--fate·狄俄斯库里
function c9950354.initial_effect(c)
	  --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xba5),2)
	c:EnableReviveLimit()
--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950354,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9950354)
	e1:SetCondition(c9950354.thcon)
	e1:SetTarget(c9950354.thtg)
	e1:SetOperation(c9950354.thop)
	c:RegisterEffect(e1)
  --boost
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950354,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabel(0)
	e3:SetCountLimit(1,99503540)
	e3:SetCost(c9950354.atkcost)
	e3:SetTarget(c9950354.atktg)
	e3:SetOperation(c9950354.atkop)
	c:RegisterEffect(e3)
 --destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950354,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(aux.bdcon)
	e2:SetTarget(c9950354.destg)
	e2:SetOperation(c9950354.desop)
	c:RegisterEffect(e2)
--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950354.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950354.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950354,0))
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9950354,1))
end 
function c9950354.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9950354.thfilter(c)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c9950354.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950354.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9950354.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9950354.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9950354.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c9950354.cfilter(c)
	return c:IsSetCard(0xba5) and (c:GetBaseAttack()>0 or c:GetBaseDefense()>0) and c:IsAbleToGraveAsCost()
end
function c9950354.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xba5)
end
function c9950354.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9950354.filter(chkc) end
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c9950354.cfilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.IsExistingTarget(c9950354.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9950354.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9950354.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c9950354.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local sc=e:GetLabelObject()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and sc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(sc:GetAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(sc:GetDefense())
		tc:RegisterEffect(e2)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950354,0))
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9950354,2))
end
function c9950354.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9950354.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and c:IsChainAttackable() then
			Duel.ChainAttack()
		end
	end
end