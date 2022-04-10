local m=53799267
local cm=_G["c"..m]
cm.name="寂寞"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(function(e)return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0 end)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_CHAINING)
		ge2:SetLabelObject(ge1)
		ge2:SetOperation(cm.reset)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsReason(REASON_COST) and re:IsActivated() then
			Duel.RegisterFlagEffect(0,m,0,0,0)
			local loc,p=tc:GetPreviousLocation(),tc:GetPreviousControler()
			local i=Duel.GetFlagEffect(0,m)*2-2
			cm[i]=loc
			cm[i+1]=p
			cm[i+2]=114
			e:SetLabelObject(re)
		end
	end
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	local ace=e:GetLabelObject():GetLabelObject()
	if ace and re~=ace then Duel.ResetFlagEffect(0,m) end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetFlagEffect(0,m)>0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return true
	end
	local aloc,ap=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_CONTROLER)
	local t={}
	for i=0,81,2 do
		local loc,p=cm[i],cm[i+1]
		cm[i]=114
		cm[i+1]=514
		if loc==114 then break end
		table.insert(t,loc)
		table.insert(t,p)
	end
	table.insert(t,aloc)
	table.insert(t,ap)
	e:SetLabel(table.unpack(t))
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local t={e:GetLabel()}
	local loc,p=t[#t-1],t[#t]
	if loc&LOCATION_REMOVED==0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,p,loc,0,1,aux.ExceptThisCard(e)) then op=Duel.SelectOption(1-tp,aux.Stringid(m,0),aux.Stringid(m,1)) else op=Duel.SelectOption(1-tp,aux.Stringid(m,1))+1 end
	if op==0 then
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,cm.repop(loc,p,e:GetHandler()))
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.rmop)
		e1:SetLabel(e:GetLabel())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.repop(loc,p,c)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,p,loc,0,1,1,c)
		if g:GetCount()>0 then
			if g:GetFirst():IsLocation(LOCATION_ONFIELD) then Duel.HintSelection(g) end
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local g,t=Group.CreateGroup(),{e:GetLabel()}
	for i=1,#t-3,2 do
		local loc,p=t[i],t[i+1]
		if not loc then break end
		g:Merge(Duel.GetMatchingGroup(Card.IsAbleToRemove,p,loc,0,nil))
	end
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
