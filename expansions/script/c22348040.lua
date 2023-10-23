--机 神 炬 城
local m=22348040
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348040,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(22348040,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,22348040)
	e2:SetCost(c22348040.rthcost)
	e2:SetTarget(c22348040.rthtg)
	e2:SetOperation(c22348040.rthop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c22348040.rthcon)
	c:RegisterEffect(e3)
	--inactivatable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetValue(c22348040.effectfilter)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetValue(c22348040.effectfilter)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetRange(LOCATION_HAND)
	e6:SetCondition(c22348040.rthcon)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetRange(LOCATION_HAND)
	e7:SetCondition(c22348040.rthcon)
	c:RegisterEffect(e7)
	
end
function c22348040.rthcon(e)
	local c=e:GetHandler()
	return c:IsPublic()
end
function c22348040.rthcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c22348040.rthcfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x700) and c:IsAbleToHandAsCost()
		and Duel.IsExistingTarget(c22348040.rthtgfilter,tp,0,LOCATION_ONFIELD,1,c,c)
end
function c22348040.rthtgfilter(c,tc)
	return c:IsAbleToHand() and c:GetEquipTarget()~=tc
end
function c22348040.rthtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(c22348040.rthcfilter,tp,LOCATION_ONFIELD,0,1,c,tp)
		else
			return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil)
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,c22348040.rthcfilter,tp,LOCATION_ONFIELD,0,1,1,c,tp)
		Duel.SendtoHand(g,nil,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c22348040.rthop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c22348040.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsSetCard(0x700) and bit.band(loc,LOCATION_ONFIELD)~=0
end

