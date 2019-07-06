--梦想愿绘 ～Drafting Reality～
function c33700919.initial_effect(c)
	c:EnableCounterPermit(0x1b)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33700919.target)
	c:RegisterEffect(e1)  
	--conf
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_DRAW)
	e7:SetCountLimit(1)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ep==tp end)
	e7:SetOperation(c33700919.cfop)
	c:RegisterEffect(e7)  
	e7:SetLabelObject(e1)
	--b2
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCost(c33700919.thcost)
	e3:SetTarget(c33700919.thtg)
	e3:SetOperation(c33700919.thop)
	c:RegisterEffect(e3)
	e3:SetLabelObject(e1)
end
function c33700919.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c33700919.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700919.filter,tp,LOCATION_DECK,0,1,nil,e:GetLabelObject():GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33700919.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33700919.filter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c33700919.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and e:GetHandler():GetCounter(0x1b)>2 end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	e:SetLabel(e:GetLabelObject():GetLabel())
end 
function c33700919.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	e:SetLabel(ac)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c33700919.cfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,33700919)
	Duel.ConfirmCards(1-tp,eg)
	e:GetHandler():AddCounter(0x1b,#eg)
	local ct=eg:FilterCount(Card.IsCode,nil,e:GetLabelObject():GetLabel())
	if ct>0 and Duel.Recover(tp,c:GetCounter(0x1b)*1000,REASON_EFFECT)~=0 then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end