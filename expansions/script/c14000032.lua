--余烬少女
local m=14000032
local cm=_G["c"..m]
function cm.initial_effect(c)
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE)
	e1:SetValue(14000021)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(cm.tgcost)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
end
function cm.TM(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Marsch
end
function cm.ctfilter(c)
	return c:IsDiscardable() and cm.TM(c)
end
function cm.ctfilter1(c)
	return c:IsDiscardable() and not cm.TM(c)
end
function cm.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(cm.ctfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,1)) or Duel.IsExistingMatchingCard(cm.ctfilter1,tp,LOCATION_HAND,0,1,nil) end
	local g=Group.CreateGroup()
	if not Duel.IsPlayerCanDraw(tp,1) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		g=Duel.SelectMatchingCard(tp,cm.ctfilter,tp,LOCATION_HAND,0,1,1,nil)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
		if cm.TM(g:GetFirst()) then
			e:SetLabel(1)
		else
			e:SetLabel(0)
		end
	end
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.tgfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local draw=e:GetLabel()==1
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) and (not draw or Duel.IsPlayerCanDraw(tp,1))
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	if draw then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c,draw=e:GetHandler(),e:GetLabel()==1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		local lv=tc:GetLevel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,1)
		e1:SetValue(cm.aclimit)
		e1:SetLabel(tc:GetCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	if draw then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end