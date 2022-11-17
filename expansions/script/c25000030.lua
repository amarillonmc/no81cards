local m=25000030
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,function(c)return c:IsLevelAbove(0)end,cm.xyzcheck,3,3)  
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.rmcost)  
	e1:SetTarget(cm.rmtg)
	e1:SetOperation(cm.rmop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_BATTLE_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+10000)
	e2:SetCondition(cm.rmcon1)
	e2:SetCost(cm.rmcost1)
	e2:SetTarget(cm.rmtg1)
	e2:SetOperation(cm.rmop1)
	c:RegisterEffect(e2)
	--xyz 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,m+20000)
	e3:SetTarget(cm.xyztg)
	e3:SetOperation(cm.xyzop)
	c:RegisterEffect(e3)
end
function cm.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==1 and g:GetClassCount(Card.GetAttribute)==g:GetCount()
end
function cm.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=aux.bpcon()
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return (b1 or b2) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	e:SetLabel(0)
	local ov=99
	local ct=Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if not b1 then ov=ct end
	local x=e:GetHandler():RemoveOverlayCard(tp,1,ov,REASON_COST)
	if b1 and b2 then
		if x>ct then op=Duel.SelectOption(tp,aux.Stringid(m,3)) else op=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4)) end
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,3)) else op=Duel.SelectOption(tp,aux.Stringid(m,4))+1 end
	if op==0 then e:SetCategory(0) else
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,x,1-tp,LOCATION_ONFIELD)
	end
	e:SetLabel(op,x)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local op,x=e:GetLabel()
	if op==0 then
		if c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DIRECT_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
	else
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil) 
		if g:GetCount()>=x then 
			local rg=g:Select(tp,x,x,nil)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function cm.rmcon1(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)  
end
function cm.rmcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.rmtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler() 
	local a,b=Duel.GetBattleMonster(tp)
	if chk==0 then return a and b and b:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,b,1,0,0)
end
function cm.rmop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a,b=Duel.GetBattleMonster(tp)
	if b then 
	Duel.Remove(b,POS_FACEUP,REASON_EFFECT)
	end 
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) then 
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function cm.xyzfil(c,e,tp) 
	local g1=Duel.GetOverlayGroup(tp,1,1) 
	local g2=c:GetOverlayGroup() 
	g1:Sub(g2) 
	return c:IsType(TYPE_XYZ) and g1:GetCount()>0 
end
function cm.xyztg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(cm.xyzfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end  
	Duel.SelectTarget(tp,cm.xyzfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then 
	local g1=Duel.GetOverlayGroup(tp,1,0) 
	local g2=tc:GetOverlayGroup() 
	g1:Sub(g2)  
	Duel.Overlay(tc,g1)
	end
end



