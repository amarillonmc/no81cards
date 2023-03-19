local m=42621003
local cm=_G["c"..m]

function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--adjust
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end

function cm.tgfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove(tp,POS_FACEDOWN)
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,0x40,nil)
	local g2=Duel.GetFieldGroup(tp,0,0x20)
	local g3=Duel.GetFieldGroup(tp,0x04,0x04)
	if chk==0 then return (#g1>0 and g1:FilterCount(cm.tgfilter,nil)==#g1) or (#g2>0 and g2:FilterCount(Card.IsAbleToDeck,nil)==#g2) or #g3>0 end
	if #g1>0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,#g1,nil,nil)
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,nil,1-tp,LOCATION_EXTRA)
	end
	if #g2>0 then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g2,#g2,nil,nil)
	else
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,nil,1-tp,LOCATION_REMOVED)
	end
	if #g3>0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g3,#g3,nil,nil)
	else
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,nil,tp,LOCATION_ONFIELD)
	end
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,0x40,nil)
	local g2=Duel.GetFieldGroup(tp,0,0x20)
	local g3=Duel.GetFieldGroup(tp,0x04,0x04)
	local off=1
	local ops={}
	local opval={}
	if #g1>0 and g1:FilterCount(cm.tgfilter,nil)==#g1 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=1
		off=off+1
	end
	if #g2>0 and g2:FilterCount(Card.IsAbleToDeck,nil)==#g2 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=2
		off=off+1
	end
	if #g3>0 then
		ops[off]=aux.Stringid(m,3)
		opval[off-1]=3
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.Remove(g1,POS_FACEDOWN,REASON_EFFECT)
	elseif opval[op]==2 then
		Duel.SendtoDeck(g2,nil,2,REASON_EFFECT)
	elseif opval[op]==3 then
		Duel.Destroy(g3,REASON_EFFECT)
		if Duel.GetOperatedGroup():GetCount()>0 then
			local g=Duel.GetOperatedGroup()
			g:KeepAlive()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(0,1)
			e1:SetLabelObject(g)
			e1:SetValue(cm.activeturnlimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end

function cm.activeturnlimit(e,re,tp)
	return e:GetLabelObject():IsContains(re:GetHandler())
end