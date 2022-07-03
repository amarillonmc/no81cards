--风雨先驱者 焰闪
--22.07.03
local m=11451672
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	aux.AddFusionProcCodeFun(c,m-40,aux.FilterBoolFunction(Card.IsType,TYPE_SPELL+TYPE_TRAP),1,true,true)
	aux.AddContactFusionProcedure(c,cm.cfilter,LOCATION_REMOVED,0,cm.tdcfop(c)):SetCountLimit(1,11451631+EFFECT_COUNT_CODE_OATH)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(cm.splimit)
	c:RegisterEffect(e0)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(cm.thcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
end
function cm.tdcfop(c)
	return function(g)
				if #g==0 then return end
				local tp=c:GetControler()
				local dg=g:Filter(Card.IsAbleToHandAsCost,nil)
				local te=Duel.IsPlayerAffectedByEffect(tp,11451674)
				local cg=g:Filter(Card.IsFacedown,nil)
				if te and #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(11451674,0)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
					local rg=dg:Select(tp,1,1,nil)
					g:Sub(rg)
					Duel.SendtoHand(rg,nil,REASON_COST)
					Duel.ConfirmCards(1-tp,rg)
					te:UseCountLimit(tp)
				end
				Duel.SendtoDeck(g,nil,2,REASON_COST)
				if #cg>0 then Duel.ConfirmCards(1-tp,cg) end
			end
end
function cm.cfilter(c)
	return (c:IsFusionCode(m-40) or c:IsType(TYPE_SPELL+TYPE_TRAP)) and c:IsAbleToDeckOrExtraAsCost()
end
function cm.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function cm.cfilter2(c)
	return c:GetType()==TYPE_TRAP and c:IsAbleToGraveAsCost()
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.thfilter(c)
	return c:IsCode(11451631) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end