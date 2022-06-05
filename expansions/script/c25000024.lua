--超甲龙 极骇时升
function c25000024.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c25000024.mfilter,c25000024.xyzcheck,3,3) 
	--Destroy  
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,25000024)
	e1:SetCost(c25000024.decost)
	e1:SetTarget(c25000024.detg)
	e1:SetOperation(c25000024.deop)
	c:RegisterEffect(e1)
	--skip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25000024,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,15000024)
	e2:SetCondition(c25000024.skcon)
	e2:SetCost(c25000024.skcost)
	e2:SetTarget(c25000024.sktg)
	e2:SetOperation(c25000024.skop)
	c:RegisterEffect(e2)
	if not c25000024.global_check then
		c25000024.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING) 
		ge1:SetCondition(c25000024.checkcon)	 
		ge1:SetOperation(c25000024.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c25000024.mfilter(c,xyzc)
	return c:IsRace(RACE_INSECT) and c:IsLevelAbove(1)
end
function c25000024.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==1 
end
function c25000024.checkcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.GetCurrentChain()>=2 
end
function c25000024.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,25000024,RESET_PHASE+PHASE_END,0,1)
end
function c25000024.decost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c25000024.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.GetFieldGroup(1-tp,LOCATION_MZONE,0):GetCount()>0
	local b2=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_ONFIELD,c,TYPE_SPELL+TYPE_TRAP)>0
	if chk==0 then return b1 or b2 end
	local s=0
	if b1 and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(25000024,0))
	end
	if not b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(25000024,1))+1
	end
	if b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(25000024,0),aux.Stringid(25000024,1))
	end
	e:SetLabel(s)
	local g=nil
	if s==0 then
		g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	end
	if s==1 then
		g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,c,TYPE_SPELL+TYPE_TRAP)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c25000024.deop(e,tp,eg,ep,ev,re,r,rp)
	local g=nil
	if e:GetLabel()==0 then
		g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	end
	if e:GetLabel()==1 then
		g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	end
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
	end
end
function c25000024.skcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,25000024)~=0 and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) 
end
function c25000024.skcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c25000024.sktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c25000024.skop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=Duel.SelectOption(tp,aux.Stringid(25000024,2),aux.Stringid(25000024,3),aux.Stringid(25000024,4),aux.Stringid(25000024,5))
	local p=Duel.GetTurnPlayer()
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_BP)
	e0:SetTargetRange(1,0)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,p)
	Duel.SkipPhase(p,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(p,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(p,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(p,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(p,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(p,PHASE_END,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,p)
	if op>=1 then Duel.SkipPhase(p,PHASE_DRAW,RESET_PHASE+PHASE_END,2) end
	if op>=2 then Duel.SkipPhase(p,PHASE_STANDBY,RESET_PHASE+PHASE_END,2) end
	if op>=3 then
		Duel.SkipPhase(p,PHASE_MAIN1,RESET_PHASE+PHASE_END,2)
		local ct=1
		if Duel.GetCurrentPhase()<=PHASE_BATTLE_START then ct=2 end 
		local e2=Effect.CreateEffect(c)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_EP)
		e2:SetTargetRange(1,0)
		e2:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN,ct)
		Duel.RegisterEffect(e2,p)
	end
end
