--结界守护灵 加丝缇
local cm,m=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,11451599)
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.adcon)
	e1:SetCost(cm.adcost)
	e1:SetTarget(cm.adtg)
	e1:SetOperation(cm.adop)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--ritual
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetLabelObject(e0)
	e2:SetCondition(cm.adcon2)
	e2:SetCost(cm.adcost2)
	e2:SetTarget(cm.adtg2)
	e2:SetOperation(cm.adop2)
	c:RegisterEffect(e2)
	local e5=e2:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function cm.filter(c,tp,se)
	if not (se==nil or c:GetReasonEffect()~=se) then return false end
	return c:IsControler(tp)
end
function cm.adcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,1-tp)
end
function cm.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,4))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
end
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,c)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,c)
	if chk==0 then return #g1>0 and #g2>0 and Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1+g2,2,PLAYER_ALL,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function cm.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevel(7,8) and c:IsAbleToHand()
end
function cm.fselect(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)<=1 and g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=1 and g:FilterCount(Card.IsLocation,nil,LOCATION_ONFIELD)<=1
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=aux.ExceptThisCard(e)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,c)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,c)
	if #g1>0 and #g2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg1=g1:SelectSubGroup(tp,cm.fselect,false,1,3)
		local sg2=g2:SelectSubGroup(1-tp,cm.fselect,false,1,3)
		if Duel.SendtoDeck(sg1+sg2,nil,2,REASON_EFFECT)>0 then
			local og=Duel.GetOperatedGroup()
			local ct1=#Group.__band(og,sg1)
			local ct2=#Group.__band(og,sg2)
			if ct1==0 and ct2==0 then return end
			Duel.BreakEffect()
			if ct1>0 then Duel.Draw(tp,ct1,REASON_EFFECT) end
			if ct2>0 then Duel.Draw(1-tp,ct2,REASON_EFFECT) end
		end
	end
end
function cm.adcon2(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(cm.filter,1,nil,tp,se)
end
function cm.adcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	local pg=Duel.GetMatchingGroup(Card.IsPublic,tp,LOCATION_HAND,0,nil)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	local dc=Duel.GetOperatedGroup():GetFirst()
	if dc and not pg:IsContains(dc) then e:SetLabel(1) else e:SetLabel(0) end
end
function cm.adtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.adop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
		if e:GetLabel()==1 then
			e:SetLabel(0)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(m,4))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e:GetHandler():RegisterEffect(e1)
		elseif e:GetLabel()==0 then
			e:GetHandler():RegisterFlagEffect(11451544,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			local eset={e:GetHandler():IsHasEffect(EFFECT_PUBLIC)}
			if #eset>0 then
				for _,ae in pairs(eset) do
					if ae:IsHasType(EFFECT_TYPE_SINGLE) then
						ae:Reset()
					else
						local tg=ae:GetTarget() or aux.TRUE
						ae:SetTarget(function(e,c,...) return tg(e,c,...) and c:GetFlagEffect(11451544)==0 end)
					end
				end
			end
		end
	end
end