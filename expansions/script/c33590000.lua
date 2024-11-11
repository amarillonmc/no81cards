local m=33590000
local cm=_G["c"..m]
function cm.initial_effect(c)
	---Draw and Back
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.backcon)
	e1:SetCost(cm.backcost)
	e1:SetTarget(cm.backtg)
	e1:SetOperation(cm.backop)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.drawcon)
	e2:SetCost(cm.drawcost)
	e2:SetTarget(cm.drawtg)
	e2:SetOperation(cm.drawop)
	c:RegisterEffect(e2)
end
function cm.backcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	local g1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	    if g>g1 then
	        e:SetLabel(g-g1)
	    end
	return g>g1
end
function cm.backcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.backtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local nb=e:GetLabel()
	    if chk==0 then return Duel.IsPlayerCanDraw(tp,nb)
        end
end
function cm.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local nb=e:GetLabel()
	if c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		if Duel.Draw(tp,nb,REASON_EFFECT)==0 then return end
		Duel.ShuffleHand(tp)
		Duel.SendtoGrave(c,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,nb,nb,nil)
		if nb>0 then
			Duel.BreakEffect()
			if g:GetCount()>0 then
				Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
		end
	end
end
function cm.drawcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local g1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	return g>g1
end
function cm.refilter(c,e,tp)
    return c:IsCode(m) and c:IsAbleToRemoveAsCost()
end
function cm.drawcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.refilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsPlayerCanRemove(tp,c,REASON_COST) end
	local nb=Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	e:SetLabel(nb)
end
function cm.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local nb=e:GetLabel()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,nb) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,nb)
end
function cm.drawop(e,tp,eg,ep,ev,re,r,rp)
    local nb=e:GetLabel()
	Duel.Draw(tp,nb,REASON_EFFECT)
end