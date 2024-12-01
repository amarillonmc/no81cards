local m=11223438
local cm=_G["c"..m]
cm.name="精灵的残识--夜魅之泪"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Act In Hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
	--Draw Or To Grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	--To Hand Or Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,4))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,m)
	e4:SetCost(cm.thcost)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
end
--Act In Hand
function cm.handfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x581)
end
function cm.handcon(e)
	return Duel.IsExistingMatchingCard(cm.handfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
--Draw Or To Grave
function cm.costfilter(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsType(TYPE_EQUIP) and c:IsAbleToRemoveAsCost()
end
function cm.tgfilter(c)
	return c:GetAttack()==500 and c:GetDefense()==500 and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local sel=0
		if Duel.IsPlayerCanDraw(tp,1) then sel=sel+1 end
		if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
			and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
		sel=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(m,2))
	else
		Duel.SelectOption(tp,aux.Stringid(m,3))
	end
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		e:SetCategory(CATEGORY_HANDES+CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_DECK)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local sel=e:GetLabel()
	if sel==1 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
--To Hand Or Special Summon
function cm.thfilter(c,e,tp)
	return not c:IsType(TYPE_TOKEN)
		and c:IsFaceup() and c:GetAttack()==500 and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and cm.thfilter(chkc,e,tp) end
	if chk==0 then return eg:IsExists(cm.thfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=eg:FilterSelect(tp,cm.thfilter,1,1,nil,e,tp)
	Duel.SetTargetCard(g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local b1=tc:IsAbleToHand()
		local b2=tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		if b1 and (not b2 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end