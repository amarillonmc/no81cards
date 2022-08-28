--废弃物回收装置
local m=30005135
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e31=Effect.CreateEffect(c)
	e31:SetCategory(CATEGORY_EQUIP)
	e31:SetType(EFFECT_TYPE_ACTIVATE)
	e31:SetCode(EVENT_FREE_CHAIN)
	e31:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e31:SetTarget(cm.target)
	e31:SetOperation(cm.operation)
	c:RegisterEffect(e31)
	--Equip limit
	local e32=Effect.CreateEffect(c)
	e32:SetType(EFFECT_TYPE_SINGLE)
	e32:SetCode(EFFECT_EQUIP_LIMIT)
	e32:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e32:SetValue(1)
	c:RegisterEffect(e32)
	--Effect 1
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_GRAVE_ACTION+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.eqecon)
	e3:SetTarget(cm.eqetg)
	e3:SetOperation(cm.eqeop)
	c:RegisterEffect(e3)
	--Effect 2 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)	
end
--Activate
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
--Effect 1
function cm.eqecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget() 
	return ec and ec:GetEquipGroup():IsContains(c)
end
function cm.eqetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c)  end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.eqeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())  
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,#g,nil)
		Duel.HintSelection(sg)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA)
			and #og>=2 and #tg>=#og
			and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			local sg1=tg:Select(tp,#og,#og,nil)
			Duel.HintSelection(sg1)
			if Duel.SendtoDeck(sg1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0
				and ec and ec:GetEquipGroup():IsContains(c) 
				and c:IsAbleToHand() then
				Duel.SendtoHand(c,nil,REASON_EFFECT)
			end
		end
	end
end
