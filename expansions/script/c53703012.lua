local m=53703012
local cm=_G["c"..m]
cm.name="终局圆盘生物 布莱克恩多"
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,nil,10,2,nil,nil,99)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_PZONE)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e0:SetCountLimit(1)
	e0:SetCost(cm.rmcost)
	e0:SetTarget(cm.rmtg)
	e0:SetOperation(cm.rmop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTarget(cm.pencon)
	e1:SetOperation(cm.penop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)
end
function cm.penfilter(c)
	return c:IsSetCard(0x3533) and (c:IsType(TYPE_MONSTER) or c:GetOriginalType()&TYPE_MONSTER~=0) and c:IsCanOverlay()
end
function cm.penfilter2(c)
	return not c:IsLocation(LOCATION_PZONE)
end
function cm.fselect(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_PZONE)>0
end
function cm.pencon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local ph=Duel.GetCurrentPhase()
	local pg=Duel.GetMatchingGroup(cm.penfilter,tp,LOCATION_ONFIELD,0,nil)
	return Duel.GetCurrentChain()==0 and ((Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) or pg:IsExists(Card.IsLocation,1,nil,LOCATION_PZONE)) and #pg>4 and Duel.GetTurnPlayer()==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local pg=Duel.GetMatchingGroup(cm.penfilter,tp,LOCATION_ONFIELD,0,nil)
	local g=nil
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) then g=pg:Select(tp,5,5,nil) else g=pg:SelectSubGroup(tp,cm.fselect,false,5,5) end
	local dg=Group.CreateGroup()
	for tc in aux.Next(g) do
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then dg:Merge(mg) end
	end
	c:SetMaterial(g)
	local xc=g:Filter(cm.penfilter2,nil):GetFirst()
	if #dg>0 then g:Merge(mg) end
	g:RemoveCard(xc)
	Duel.Overlay(xc,g)
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	local mg2=xc:GetOverlayGroup()
	Duel.Overlay(c,mg2)
	Duel.Overlay(c,Group.FromCards(xc))
	c:CompleteProcedure()
end
function cm.atkval(e,c)
	return c:GetOverlayCount()*600
end
function cm.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	if chk==0 then return og:IsExists(Card.IsAbleToDeckOrExtraAsCost,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local sg=og:FilterSelect(tp,Card.IsAbleToDeckOrExtraAsCost,1,1,nil)
	Duel.SendtoExtraP(sg,tp,REASON_COST)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) and Duel.GetCurrentChain()==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,1-tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsAttackAbove(500) and Duel.IsPlayerCanDiscardDeck(1-tp,1) then
			Duel.BreakEffect()
			Duel.DiscardDeck(1-tp,math.floor(tc:GetAttack()/500),REASON_EFFECT)
			local g=Duel.GetOperatedGroup()
			if #g>0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local sg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE):FilterSelect(tp,Card.IsAbleToRemove,1,99,nil)
				Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end
