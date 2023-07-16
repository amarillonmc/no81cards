--无法听见的神谕
local m=75000718
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e51=Effect.CreateEffect(c)
	e51:SetCategory(CATEGORY_EQUIP)
	e51:SetType(EFFECT_TYPE_ACTIVATE)
	e51:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e51:SetCode(EVENT_FREE_CHAIN)
	e51:SetTarget(cm.target)
	e51:SetOperation(cm.operation)
	c:RegisterEffect(e51)
	--equip limit
	local e52=Effect.CreateEffect(c)
	e52:SetType(EFFECT_TYPE_SINGLE)
	e52:SetCode(EFFECT_EQUIP_LIMIT)
	e52:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e52:SetValue(cm.eqlimit)
	c:RegisterEffect(e52)
	--Effect 1
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(cm.efilter)
	c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetCondition(cm.eqecon)
	e2:SetValue(cm.atlimit)
	c:RegisterEffect(e2)
	--Effect 2  
	local e02=Effect.CreateEffect(c)  
	e02:SetDescription(aux.Stringid(m,0))
	e02:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e02:SetType(EFFECT_TYPE_IGNITION)
	e02:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e02:SetRange(LOCATION_GRAVE)
	e02:SetCost(aux.bfgcost)
	e02:SetTarget(cm.drtg)
	e02:SetOperation(cm.drop)
	c:RegisterEffect(e02)  
end
function cm.eqlimit(e,c)
	return c:IsSetCard(0x750)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x750)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
--Effect 1
function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
function cm.eqecon(e)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget() 
	return ec and ec:GetEquipGroup():IsContains(c)
end
function cm.atlimit(e,c)
	local ec=e:GetHandler():GetEquipTarget() 
	return c~=ec
end
--Effect 2
function cm.tdfilter(c)
	local b1=c:IsSetCard(0x750) and c:IsType(TYPE_MONSTER)
	return  b1 and c:IsAbleToDeck()
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,1,5,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<=0 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
--Effect 3 
--Effect 4 
--Effect 5  
