--六合精工 千里江山图
local m=33201356
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c33201350") end,function() require("script/c33201350") end)
function cm.initial_effect(c)
	--send to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.tdtg)
	e1:SetOperation(cm.tdop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,m+10000)
	e2:SetTarget(cm.sthtg)
	e2:SetOperation(cm.sthop)
	c:RegisterEffect(e2)
	--creat table
	VHisc_CNTdb.creattable()
end
cm.VHisc_CNTreasure=true

--e1
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,tp,2,REASON_EFFECT)~=0 then
----------------code table add code----------------------
		if not VHisc_CNTdb.codeck(VHisc_CNTN,tc) then
			VHisc_CNTN[#VHisc_CNTN+1]=tc:GetOriginalCode()
		end
	end
end


--e2
function cm.thfilter(c)
	return VHisc_CNTdb.nck(c)
end
function cm.sthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local dg=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
		return dg:GetClassCount(Card.GetCode)>=3 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>=1 end
end
function cm.sthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=3 and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg1=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
		Duel.ConfirmCards(1-tp,sg1)
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_CONTINUOUS+TYPE_SPELL)
		c:RegisterEffect(e1,true)
		sg1:KeepAlive()
		--tohand
		local e0=Effect.CreateEffect(c)
		e0:SetDescription(aux.Stringid(m,1))
		e0:SetCategory(CATEGORY_TOHAND)
		e0:SetType(EFFECT_TYPE_QUICK_O)
		e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e0:SetCode(EVENT_CHAINING)
		e0:SetRange(LOCATION_SZONE)
		e0:SetLabelObject(sg1)
		e0:SetCountLimit(1)
		e0:SetCondition(cm.thcon)
		e0:SetTarget(cm.thtg)
		e0:SetOperation(cm.thop)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		c:RegisterEffect(e0)
	end
end

--e0
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return VHisc_CNTdb.nck(re:GetHandler()) and re:GetHandler()~=e:GetHandler()
end
function cm.cfilter(c,cg)
	return cg:IsExists(Card.IsCode,1,nil,c:GetCode()) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=e:GetLabelObject()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil,cg) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=e:GetLabelObject()
	if c:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil,cg) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil,cg)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			local thc=g:GetFirst()
			local rmc=cg:Filter(Card.IsCode,nil,thc:GetCode()):GetFirst()
			cg:RemoveCard(rmc)
			cg:KeepAlive()
			e:SetLabelObject(cg)
		end
	end
end