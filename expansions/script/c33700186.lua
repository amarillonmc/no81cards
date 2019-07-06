--动物朋友 九州长尾林鸮
local m=33700186
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return not e:GetHandler():IsPublic() end
	end)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.operation1)
	c:RegisterEffect(e1)	
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.thfilter(c)
	return c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(cm.aclimit)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cm.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	return  re:GetHandler():IsCode(tc:GetCode()) and not re:GetHandler():IsImmuneToEffect(e)
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(m,3))
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return false end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)	
	if g:GetClassCount(Card.GetCode)==3 then
		local b1=g:IsExists(Card.IsAbleToHand,1,nil)
		local b2=e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsDiscardable() and e:GetHandler():IsLocation(LOCATION_HAND) and g:IsExists(function(c) return c:IsSetCard(0x442) and c:IsAbleToHand() end,1,nil)
		if b2 and Duel.SelectYesNo(tp,m*16+2) then
			Duel.Hint(HINT_SOUND,0,aux.Stringid(m,5))
			local tg=g:Filter(function(c) return c:IsSetCard(0x442) and c:IsAbleToHand() end,nil)
			Duel.BreakEffect()
			Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT+REASON_DISCARD)
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			g:Sub(Duel.GetOperatedGroup())
			Duel.ConfirmCards(1-tp,tg)
		elseif b1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
			Duel.Hint(HINT_SOUND,0,aux.Stringid(m,4))
			Duel.BreakEffect()
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			g:Sub(Duel.GetOperatedGroup())
			Duel.ConfirmCards(1-tp,tg)			
		end
	else
		local hg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
		if hg:GetCount()>=3 then
			local tg=hg:RandomSelect(tp,3)
			Duel.BreakEffect()
			Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
		end
	end
	if g:GetCount()>0 then
		Duel.SortDecktop(tp,tp,g:GetCount())
	end
end