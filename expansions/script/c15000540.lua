local m=15000540
local cm=_G["c"..m]
cm.name="橙影泣之恶虺"
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,cm.xyzfilter,4,2)
	c:EnableReviveLimit()
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.sprcon)
	e0:SetOperation(cm.sprop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	cm.FlipEffect_Deobra=e1
	--be target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.thcon)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	cm.TargetEffect_Deobra=e2
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,15000540)
	e3:SetCondition(cm.immcon)
	e3:SetTarget(cm.immtg)
	e3:SetOperation(cm.immop)
	c:RegisterEffect(e3)
	--face-down  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,4))  
	e4:SetCategory(CATEGORY_POSITION)  
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetTarget(cm.postg)  
	e4:SetOperation(cm.posop)  
	c:RegisterEffect(e4)  
end
function cm.xyzfilter(c,sg)
	return c:IsRace(RACE_REPTILE)
end
function cm.sprzonefilter(c,sc,tp)
	return c:IsFacedown() and c:IsXyzLevel(sc,4) and c:IsCanOverlay(sc) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and Duel.IsExistingMatchingCard(cm.sprfilter,tp,LOCATION_MZONE,0,1,c,sc)
end
function cm.sprfilter(c,sc)
	return c:IsFacedown() and c:IsXyzLevel(sc,4) and c:IsCanOverlay(sc)
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.sprzonefilter,tp,LOCATION_MZONE,0,nil,c,c:GetControler())
	return g:GetCount()>=1
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.sprzonefilter,tp,LOCATION_MZONE,0,nil,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local mg=g:Select(tp,1,1,nil)
	local tc=mg:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=Duel.SelectMatchingCard(tp,cm.sprfilter,tp,LOCATION_MZONE,0,1,1,tc,c)
	local ttc=sg:GetFirst()
	mg:Merge(sg)
	Duel.ConfirmCards(1-tp,mg)
	local mg1=tc:GetOverlayGroup()
	if mg1:GetCount()~=0 then
		Duel.SendtoGrave(mg1,REASON_RULE)
	end
	local mg2=ttc:GetOverlayGroup()
	if mg2:GetCount()~=0 then
		Duel.SendtoGrave(mg2,REASON_RULE)
	end
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
	mg:DeleteGroup()
end
function cm.filter(c)
	return c:IsCanOverlay()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsCanOverlay() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanOverlay,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsCanOverlay,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	if g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local mg1=tc:GetOverlayGroup()
		if mg1:GetCount()~=0 then
			Duel.SendtoGrave(mg1,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(e:GetHandler()) and e:GetHandler():IsFacedown()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local pos=Duel.SelectPosition(tp,e:GetHandler(),POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)
	Duel.ChangePosition(e:GetHandler(),pos,pos,pos,pos,true)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsCanOverlay() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanOverlay,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsCanOverlay,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,2,nil)
	local ag=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if ag:GetCount()~=0 then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,ag,ag:GetCount(),0,0)
	end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=tg:GetFirst()
	while tc do
		if tc and tc:IsRelateToEffect(e) then
			local mg1=tc:GetOverlayGroup()
			if mg1:GetCount()~=0 then
				Duel.SendtoGrave(mg1,REASON_RULE)
			end
			Duel.Overlay(c,Group.FromCards(tc))
		end
		tc=tg:GetNext()
	end
end
function cm.immcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(e:GetHandler()) and e:GetHandler():IsFaceup()
end
function cm.tgfilter(c,sc)
	return (c:IsType(TYPE_FLIP) and (c:IsAbleToHand() or c:IsAbleToGrave()) and c:IsLocation(LOCATION_DECK)) or (bit.band(c:GetOriginalType(),TYPE_FLIP)~=0 and sc:GetOverlayGroup():IsContains(c))
end
function cm.immtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(cm.efilter)
		e1:SetLabel(re:GetActiveType())
		c:RegisterEffect(e1)

local ag=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_DECK,0,nil,e:GetHandler())
local bg=e:GetHandler():GetOverlayGroup():Filter(cm.tgfilter,nil,e:GetHandler())
ag:Merge(bg)

		if ag:GetCount()~=0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local g=ag:Select(tp,1,1,nil)
			if g:GetCount()>0 then
				local tc=g:GetFirst()
				if tc and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
					Duel.SendtoHand(tc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tc)
				else
					Duel.SendtoGrave(tc,REASON_EFFECT)
				end
			end
		end
	end
end
function cm.efilter(e,te)
	return te:IsActiveType(e:GetLabel()) and te:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return c:IsCanTurnSet() end  
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)  
end  
function cm.posop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and c:IsFaceup() then  
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)  
	end  
end