--Proto-Summoner 志麻子
function c33700024.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33700024,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c33700024.secost)
	e1:SetTarget(c33700024.setg)
	e1:SetOperation(c33700024.seop)
	c:RegisterEffect(e1)
	--scale
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33700024,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c33700024.con)
	e2:SetOperation(c33700024.op)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetTarget(c33700024.desreptg)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33700024,3))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c33700024.cost)
	e4:SetTarget(c33700024.thtg)
	e4:SetOperation(c33700024.thop)
	c:RegisterEffect(e4)
end
function c33700024.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6440) and not c:IsPublic()
	and Duel.IsExistingMatchingCard(c33700024.sefilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c33700024.sefilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c33700024.secost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700024.cfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c33700024.cfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c33700024.setg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33700024.seop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33700024.sefilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
end
end
function c33700024.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0x3440) and e:GetHandler():GetRightScale()~=11 and e:GetHandler():GetLeftScale()~=11 
end
function c33700024.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetValue(11)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e2)
	e:GetHandler():RegisterFlagEffect(33700024,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,0,1)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetDescription(aux.Stringid(33700024,4))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetLabelObject(c)
	e3:SetCondition(c33700024.descon)
	e3:SetOperation(c33700024.desop)
	Duel.RegisterEffect(e3,tp)
end
function c33700024.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(33700024)~=0 then
		return true
	else
		e:Reset()
		return false
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c33700024.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
function c33700024.filter(c)
	return  c:IsFaceup() and  c:IsSetCard(0x6440) and c:IsReleasableByEffect() and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c33700024.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and Duel.CheckReleaseGroup(tp,c33700024.filter,1,c) end
	if Duel.SelectYesNo(tp,aux.Stringid(33700024,2)) then
		local g=Duel.SelectReleaseGroup(tp,c33700024.filter,1,1,c)
		Duel.Release(g,REASON_EFFECT+REASON_REPLACE)  
		return true
	else return false end
end
function c33700024.costfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function c33700024.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700024.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c33700024.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c33700024.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
	and c:IsAbleToDeck() and c:IsAbleToRemove()
end
function c33700024.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c33700024.thfilter(chkc) end
	if chk==0 then return  Duel.IsExistingTarget(c33700024.thfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c33700024.thfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	 Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c33700024.thop(e,tp,eg,ep,ev,re,r,rp)
	 local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
		local tc=tg:Filter(Card.IsRelateToEffect,nil,e)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg1=tc:Select(1-tp,1,1,nil)
		tc:RemoveCard(sg1:GetFirst())
		if sg1 and Duel.SendtoDeck(sg1,nil,1,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		local sg2=tc:Select(tp,1,1,nil)
		tc:RemoveCard(sg2:GetFirst())
		Duel.Remove(sg2,POS_FACEUP,REASON_EFFECT)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
