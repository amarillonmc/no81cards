local cm,m = GetID()
cm.tab = { }
cm.tab[0],cm.tab[1] = {},{}
cm.eff = { }
function cm.initial_effect(c)
    aux.AddCodeList(c,31242786)
	aux.AddXyzProcedure(c,cm.f1,4,2,cm.f2,aux.Stringid(m,0),2,cm.oop)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.con)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
function cm.f1(c)
	return c:IsRace(RACE_FISH)
end
function cm.f2(c)
	return c:IsFaceup() and c:IsCode(31242786)
end
function cm.oop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local g,mg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_XYZ),Group.CreateGroup()
    for c in aux.Next(g) do
        local og = c:GetOverlayGroup()
        if #og~=0 then
		    for oc in aux.Next(og) do
		        mg:AddCard(oc)
		    end
        end
	end
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) and mg:FilterCount(Card.IsAbleToRemove,nil)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
		local g,mg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_XYZ),Group.CreateGroup()
		for c in aux.Next(g) do
		    local og = c:GetOverlayGroup()
		    if #og~=0 then
		        for oc in aux.Next(og) do
		            mg:AddCard(oc)
		        end
		    end
		end
		if Duel.Draw(p,d,REASON_EFFECT)>0 and mg:FilterCount(Card.IsAbleToRemove,nil)>0 then
		    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
            g=mg:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil)
            Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function cm.f(c)
    return (c:IsRace(RACE_AQUA) or c:IsRace(RACE_SEASERPENT) or c:IsRace(RACE_FISH))
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.f,1,nil)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	cm.tab[tp][Duel.GetTurnCount()] = cm.tab[tp][Duel.GetTurnCount()] or { }
	if chk==0 then return Duel.IsExistingMatchingCard(cm.ff,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK,0,1,nil,c,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.ff,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK,0,1,1,nil,c,e,tp,eg,ep,ev,re,r,rp)
	local te=g:GetFirst():CheckActivateEffect(true,true,false) or g:GetFirst():GetActivateEffect()
	table.insert(cm.tab[tp][Duel.GetTurnCount()],g:GetFirst():GetCode())
	e:SetLabelObject(te)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.ff(c,exc,e,tp,eg,ep,ev,re,r,rp)
	local te=c:CheckActivateEffect(true,true,false) or c:GetActivateEffect()
	local tg=te and te:GetTarget()
	return c:IsCode(94626050,51324455) and cm.ck(c,tp) and c:IsAbleToRemoveAsCost() and te and te:GetOperation() and ((not tg) or tg(e,tp,eg,ep,ev,re,r,rp,0,nil,exc))
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	if chkc then
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc,c)
	end
	if chk==0 then return true end
	e:SetProperty(te:GetProperty())
	table.insert(cm.eff,{te:GetLabelObject(),te:GetLabelObject(),te})
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	te:SetLabel(cm.eff[#cm.eff][1])
	te:SetLabelObject(cm.eff[#cm.eff][2])
	Duel.ClearOperationInfo(0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetLabelObject(e)
	e1:SetType(EVENT_CHAIN_DISABLED)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
	if re==e then
	    table.remove(cm.eff,#cm.eff)
	end
	e:Reset()
	end)
	e1:SetReset(RESET_CHAIN+RESET_EVENT)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local te=cm.eff[#cm.eff][3]
	e:SetLabel(te:GetLabel())
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	te:SetLabel(e:GetLabel())
	te:SetLabelObject(e:GetLabelObject())
	table.remove(cm.eff,#cm.eff)
end
function cm.ck(c,tp)
    local t = cm.tab[tp][Duel.GetTurnCount()] or {}
    if #t==0 then return true end
    for _,code in ipairs(t) do
        if c:IsCode(code) then return false end
    end
    return true
end