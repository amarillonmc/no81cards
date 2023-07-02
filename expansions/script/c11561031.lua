--料敌机先·张郃
function c11561031.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,3) 
	c:EnableReviveLimit()   
	--xx
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(11561031,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,11561031)
	e1:SetCost(c11561031.xxcost1)
	e1:SetTarget(c11561031.thtg)
	e1:SetOperation(c11561031.thop)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(11561031,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,21561031)
	e1:SetCost(c11561031.xxcost2)
	e1:SetTarget(c11561031.sktg)
	e1:SetOperation(c11561031.skop)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(11561031,1))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,31561031)
	e1:SetCondition(c11561031.cncon1)
	e1:SetCost(c11561031.xxcost3)
	e1:SetTarget(c11561031.cntg)
	e1:SetOperation(c11561031.cnop)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(11561031,1))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,41561031)
	e1:SetCondition(c11561031.cncon2)
	e1:SetCost(c11561031.xxcost4)
	e1:SetTarget(c11561031.cntg)
	e1:SetOperation(c11561031.cnop)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(11561031,1))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,51561031)
	e1:SetCondition(c11561031.cncon3)
	e1:SetCost(c11561031.xxcost5)
	e1:SetTarget(c11561031.cntg)
	e1:SetOperation(c11561031.cnop)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(11561031,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,61561031) 
	e1:SetCost(c11561031.xxcost6)
	e1:SetTarget(c11561031.rmtg)
	e1:SetOperation(c11561031.rmop)
	c:RegisterEffect(e1) 
	--ov
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(11561031,2))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetHintTiming(0,TIMING_DRAW)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,71561031)
	e2:SetCondition(c11561031.ovcon1) 
	e2:SetTarget(c11561031.ovtg)
	e2:SetOperation(c11561031.ovop)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(11561031,2))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,81561031)
	e2:SetCondition(c11561031.ovcon2) 
	e2:SetTarget(c11561031.ovtg)
	e2:SetOperation(c11561031.ovop)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(11561031,2))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,91561031)
	e2:SetCondition(c11561031.ovcon3) 
	e2:SetTarget(c11561031.ovtg)
	e2:SetOperation(c11561031.ovop)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(11561031,2))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_BATTLE_START)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,101561031)
	e2:SetCondition(c11561031.ovcon4) 
	e2:SetTarget(c11561031.ovtg)
	e2:SetOperation(c11561031.ovop)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(11561031,2))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,111561031)
	e2:SetCondition(c11561031.ovcon5) 
	e2:SetTarget(c11561031.ovtg)
	e2:SetOperation(c11561031.ovop)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(11561031,2))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,121561031)
	e2:SetCondition(c11561031.ovcon6) 
	e2:SetTarget(c11561031.ovtg)
	e2:SetOperation(c11561031.ovop)
	c:RegisterEffect(e2)
end 
function c11561031.xxcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and e:GetHandler():GetOverlayCount()>0 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	if Duel.Remove(e:GetHandler(),0,REASON_COST+REASON_TEMPORARY)~=0 then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_DRAW)
		e1:SetLabelObject(e:GetHandler())
		e1:SetCountLimit(1)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.ReturnToField(e:GetLabelObject()) end)  
		e1:SetReset(RESET_PHASE+PHASE_END) 
		Duel.RegisterEffect(e1,tp) 
	end
end
function c11561031.xxcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and e:GetHandler():GetOverlayCount()>0 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	if Duel.Remove(e:GetHandler(),0,REASON_COST+REASON_TEMPORARY)~=0 then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetLabelObject(e:GetHandler())
		e1:SetCountLimit(1)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.ReturnToField(e:GetLabelObject()) end)  
		e1:SetReset(RESET_PHASE+PHASE_END) 
		Duel.RegisterEffect(e1,tp) 
	end
end
function c11561031.xxcost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and e:GetHandler():GetOverlayCount()>0 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	if Duel.Remove(e:GetHandler(),0,REASON_COST+REASON_TEMPORARY)~=0 then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE_START+PHASE_BATTLE_START)
		e1:SetLabelObject(e:GetHandler())
		e1:SetCountLimit(1)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.ReturnToField(e:GetLabelObject()) end)  
		e1:SetReset(RESET_PHASE+PHASE_END) 
		Duel.RegisterEffect(e1,tp) 
	end
end
function c11561031.xxcost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and e:GetHandler():GetOverlayCount()>0 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	if Duel.Remove(e:GetHandler(),0,REASON_COST+REASON_TEMPORARY)~=0 then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
		e1:SetLabelObject(e:GetHandler())
		e1:SetCountLimit(1)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.ReturnToField(e:GetLabelObject()) end)  
		e1:SetReset(RESET_PHASE+PHASE_END) 
		Duel.RegisterEffect(e1,tp) 
	end
end
function c11561031.xxcost5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and e:GetHandler():GetOverlayCount()>0 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	if Duel.Remove(e:GetHandler(),0,REASON_COST+REASON_TEMPORARY)~=0 then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE_START+PHASE_END)
		e1:SetLabelObject(e:GetHandler())
		e1:SetCountLimit(1)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.ReturnToField(e:GetLabelObject()) end) 
		e1:SetReset(RESET_PHASE+PHASE_END) 
		Duel.RegisterEffect(e1,tp) 
	end
end
function c11561031.xxcost6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and e:GetHandler():GetOverlayCount()>0 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	if Duel.Remove(e:GetHandler(),0,REASON_COST+REASON_TEMPORARY)~=0 then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetLabelObject(e:GetHandler())
		e1:SetCountLimit(1)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.ReturnToField(e:GetLabelObject()) end) 
		e1:SetReset(RESET_PHASE+PHASE_END) 
		Duel.RegisterEffect(e1,tp) 
	end
end
function c11561031.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local p=Duel.GetTurnPlayer() 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,p,0,LOCATION_HAND,1,nil,p) end
	local dt=Duel.GetDrawCount(p) 
	if dt~=0 then
		aux.DrawReplaceCount=0
		aux.DrawReplaceMax=dt
		local e1=Effect.CreateEffect(e:GetHandler()) 
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,p)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-p,LOCATION_HAND)
end
function c11561031.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=Duel.GetTurnPlayer() 
	aux.DrawReplaceCount=aux.DrawReplaceCount+1 
	if aux.DrawReplaceCount<=aux.DrawReplaceMax then 
		local g=Duel.GetMatchingGroup(Card.IsAbleToHand,p,0,LOCATION_HAND,nil,p) 
		local sg=g:RandomSelect(p,1)
		Duel.SendtoHand(sg,p,REASON_EFFECT)
		Duel.ConfirmCards(1-p,sg) 
	end
end
function c11561031.sspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_XYZ) 
end 
function c11561031.sktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end
function c11561031.skop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_STANDBY)
	Duel.RegisterEffect(e2,tp)
end 
function c11561031.cncon1(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetCurrentPhase()==PHASE_MAIN1  
end 
function c11561031.cncon2(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE 
end 
function c11561031.cncon3(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetCurrentPhase()==PHASE_MAIN2 
end 
function c11561031.cntg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) or (Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_SZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) end 
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,tp,LOCATION_ONFIELD)
end 
function c11561031.cnop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	if not (Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) or (Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_SZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0)) then return end 
	local g1=Duel.GetMatchingGroup(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,nil) 
	local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_SZONE,nil) 
	g1:Merge(g2) 
	if g1:GetCount()>0 then 
		local tc=g1:Select(tp,1,1,nil):GetFirst() 
		if tc:IsLocation(LOCATION_MZONE) then 
			Duel.GetControl(tc,tp)  
		elseif tc:IsLocation(LOCATION_SZONE) then 
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true) 
			Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) 
		end  
	end 
end 
function c11561031.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil,POS_FACEDOWN) end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end 
function c11561031.rmop(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil,POS_FACEDOWN) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,99,nil) 
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY) 
		sg:KeepAlive() 
		e1:SetLabelObject(sg) 
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCountLimit(1)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) 
		return Duel.GetTurnCount()~=e:GetLabel() end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.SendtoHand(e:GetLabelObject(),tp,REASON_EFFECT) end)
		e1:SetReset(RESET_PHASE+PHASE_END,2) 
		Duel.RegisterEffect(e1,tp)
	end  
end 
function c11561031.ovcon1(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():GetOverlayCount()<Duel.GetFieldGroupCount(tp,LOCATION_HAND,0) and Duel.GetCurrentPhase()==PHASE_DRAW 
end 
function c11561031.ovcon2(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():GetOverlayCount()<Duel.GetFieldGroupCount(tp,LOCATION_HAND,0) and Duel.GetCurrentPhase()==PHASE_STANDBY 
end 
function c11561031.ovcon3(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():GetOverlayCount()<Duel.GetFieldGroupCount(tp,LOCATION_HAND,0) and Duel.GetCurrentPhase()==PHASE_MAIN1 
end 
function c11561031.ovcon4(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():GetOverlayCount()<Duel.GetFieldGroupCount(tp,LOCATION_HAND,0) and Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE 
end 
function c11561031.ovcon5(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():GetOverlayCount()<Duel.GetFieldGroupCount(tp,LOCATION_HAND,0) and Duel.GetCurrentPhase()==PHASE_MAIN2 
end 
function c11561031.ovcon6(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():GetOverlayCount()<Duel.GetFieldGroupCount(tp,LOCATION_HAND,0) and Duel.GetCurrentPhase()==PHASE_END 
end 
function c11561031.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end 
end 
function c11561031.ovop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsCanOverlay,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil) 
	local x=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)-e:GetHandler():GetOverlayCount() 
	if g:GetCount()>0 and c:IsRelateToEffect(e) and x>0 then  
		local og=g:Select(tp,1,x,nil) 
		Duel.Overlay(c,og)  
	end 
end 
 

