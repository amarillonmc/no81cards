local m=53799099
local cm=_G["c"..m]
cm.name="猛突风"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(cm.con)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_LEAVE_GRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,m)
	e4:SetCondition(cm.setcon)
	e4:SetTarget(cm.settg)
	e4:SetOperation(cm.setop)
	c:RegisterEffect(e4)
end
function cm.con(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function cm.cfilter(c,tp)
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	local ct=eg:GetCount()
	local rt=Duel.GetTargetCount(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	if ct>rt then ct=rt end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tg=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,ct,0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		for tc in aux.Next(tg) do
			Duel.SetChainLimit(cm.limit(tc))
		end
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if rg:GetCount()>0 then
		Duel.SendtoHand(rg,nil,REASON_EFFECT)
	end
end
function cm.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function cm.filter(c,tp)
	return c:IsOnField() and c:IsControler(tp)
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ep==1-tp and ex and tg~=nil and tc+tg:FilterCount(cm.filter,nil,tp)-tg:GetCount()>0
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetValue(cm.tgval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function cm.tgval(e,re,rp)
	return rp==1-e:GetOwnerPlayer()
end
