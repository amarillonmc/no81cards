local s,id=GetID()
function s.initial_effect(c)
	aux.AddXyzProcedure(c,nil,9,2,nil,nil,99)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.skipcon)
	e1:SetCost(s.skipcost)
	e1:SetTarget(s.skiptg)
	e1:SetOperation(s.skipop)
	c:RegisterEffect(e1)
end
function s.skipcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.skipcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.IsPlayerAffectedByEffect(1,181) or Duel.IsPlayerAffectedByEffect(0,183) or Duel.IsPlayerAffectedByEffect(1,180) or Duel.IsPlayerAffectedByEffect(0,184) then return false end
	local ct=5
	if Duel.IsPlayerAffectedByEffect(1,184) or Duel.IsPlayerAffectedByEffect(0,180) then ct=4 end
	if Duel.IsPlayerAffectedByEffect(1,183) or Duel.IsPlayerAffectedByEffect(0,181) then ct=3 end
	if Duel.IsPlayerAffectedByEffect(1,182) or Duel.IsPlayerAffectedByEffect(0,182) then ct=2 end
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,2,REASON_COST) end
	local rt=c:GetOverlayCount()
	local rct=c:RemoveOverlayCard(tp,2,math.min(rt,ct),REASON_COST)
	e:SetLabel(rct)
end
function s.skiptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetLabel()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*1000)
end
function s.skipop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=e:GetLabel()
	if Duel.Damage(p,ct*1000,REASON_EFFECT)==0 then return end
	Duel.BreakEffect()
	for i=180,ct+179 do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(i)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		Duel.RegisterEffect(e1,tp)
		if ct>3 then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_CANNOT_BP)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetTargetRange(0,1)
			e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
			Duel.RegisterEffect(e3,tp)
		end
	end
	for i=184,185-ct,-1 do
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(i)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetCondition(s.con)
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		Duel.RegisterEffect(e2,tp)
		if ct>2 then
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_CANNOT_BP)
			e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e4:SetTargetRange(1,0)
			e4:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
			Duel.RegisterEffect(e4,tp)
		end
	end
end
function s.con(e)
	return Duel.GetCurrentPhase()<PHASE_END
end
