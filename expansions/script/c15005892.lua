local m=15005892
local cm=_G["c"..m]
cm.name="狂音主的转魔·异言但他林"
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,cm.mfilter,6,2,cm.ovfilter,aux.Stringid(m,0),2,cm.xyzop)
	c:EnableReviveLimit()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--return
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.mfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6f43) and c:IsDisabled()
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local p=Duel.GetTurnPlayer()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and p==1-tp
end
function cm.disctfilter(c)
	return c:IsFaceup() and c:IsDisabled() and c:IsType(TYPE_EFFECT)
end
function cm.cfilter(c)
	return cm.c1filter(c) or cm.c2filter(c)
end
function cm.c1filter(c)
	return c:IsFaceup() and c:IsDisabled() and c:IsAbleToGrave() and c:IsType(TYPE_EFFECT)
end
function cm.c2filter(c)
	return c:IsFaceup() and aux.NegateMonsterFilter(c) and not c:IsDisabled()
end
function cm.ovsetcardfilter(c)
	return c:IsSetCard(0x6f43) and c:IsType(TYPE_MONSTER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.disctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chkc then return false end
	if chk==0 then return #g>0 and Duel.IsExistingTarget(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local ag=Duel.SelectTarget(tp,cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,#g,nil)
	local tgg=ag:Filter(cm.c1filter,nil)
	local disg=ag:Clone()
	disg:Sub(tgg)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tgg,#tgg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,disg,#disg,0,0)
	local lg=e:GetHandler():GetOverlayGroup()
	if lg and lg:FilterCount(cm.ovsetcardfilter,nil)>0 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	else
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then return end
	if e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)~=0 then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		local tgg=g:Filter(cm.c1filter,nil)
		local disg=g:Clone()
		disg:Sub(tgg)
		if #tgg>0 then
			Duel.SendtoGrave(tgg,REASON_EFFECT)
		end
		if #disg>0 then
			local tc=disg:GetFirst()
			while tc do
				local e0=Effect.CreateEffect(e:GetHandler())
				e0:SetType(EFFECT_TYPE_SINGLE)
				e0:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
				e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e0)
				if tc:IsFaceup() and tc:IsCanBeDisabledByEffect(e) then
					Duel.NegateRelatedChain(tc,RESET_TURN_SET)
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetCode(EFFECT_DISABLE_EFFECT)
					e1:SetValue(RESET_TURN_SET)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e1)
					local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e2:SetCode(EFFECT_DISABLE)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e2)
				end
				tc=disg:GetNext()
			end
		end
	end
end
function cm.thfilter(c)
	return c:IsSetCard(0x6f43) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) and e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsExtraDeckMonster() and Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_EXTRA) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end