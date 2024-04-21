--时越龙-极超升时
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddXyzProcedureLevelFree(c,s.mfilter,s.xyzcheck,3,3)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.skipcon)
	e1:SetCost(s.skipcost)
	e1:SetOperation(s.skipop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o*10000)
	e2:SetCost(s.descost)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()>1 then
		Duel.RegisterFlagEffect(rp,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.mfilter(c,xyzc)
	return c:IsLevelAbove(1) and c:IsRace(RACE_INSECT)
end
function s.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==1
end
function s.skipcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and Duel.GetFlagEffect(1-tp,id)>0
end
function s.skipcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.skipop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetTurnPlayer()==tp then
		if Duel.GetCurrentPhase()==PHASE_DRAW then
			Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_SKIP_SP)
			e1:SetTargetRange(1,0)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCode(EFFECT_SKIP_M1)
			e2:SetTargetRange(1,0)
			e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
			Duel.RegisterEffect(e2,tp)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetCode(EFFECT_SKIP_BP)
			e3:SetTargetRange(1,0)
			e3:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
			Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
		end
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCode(EFFECT_SKIP_M1)
			e2:SetTargetRange(1,0)
			e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
			Duel.RegisterEffect(e2,tp)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetCode(EFFECT_SKIP_BP)
			e3:SetTargetRange(1,0)
			e3:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
			Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
		end
		if Duel.GetCurrentPhase()==PHASE_MAIN1 then
			Duel.SkipPhase(tp,EFFECT_SKIP_M1,RESET_PHASE+PHASE_END,1)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetCode(EFFECT_SKIP_BP)
			e3:SetTargetRange(1,0)
			e3:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
			Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
		end
		if Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE then
			Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetCode(EFFECT_SKIP_M2)
			e3:SetTargetRange(1,0)
			e3:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
			Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
		end
		if Duel.GetCurrentPhase()==PHASE_MAIN2 then
			Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
			Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
		end
		if Duel.GetCurrentPhase()==PHASE_END then
			Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_SKIP_TURN)
		e1:SetTargetRange(0,1)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
		Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,2)
		Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,2)
		Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,2)
	elseif Duel.GetTurnPlayer()==1-tp then
		if Duel.GetCurrentPhase()==PHASE_DRAW then
			Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_SKIP_SP)
			e1:SetTargetRange(0,1)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCode(EFFECT_SKIP_M1)
			e2:SetTargetRange(0,1)
			e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
			Duel.RegisterEffect(e2,tp)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetCode(EFFECT_SKIP_BP)
			e3:SetTargetRange(0,1)
			e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
			Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
		end
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCode(EFFECT_SKIP_M1)
			e2:SetTargetRange(0,1)
			e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
			Duel.RegisterEffect(e2,tp)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetCode(EFFECT_SKIP_BP)
			e3:SetTargetRange(0,1)
			e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
			Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
		end
		if Duel.GetCurrentPhase()==PHASE_MAIN1 then
			Duel.SkipPhase(tp,EFFECT_SKIP_M1,RESET_PHASE+PHASE_END,1)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetCode(EFFECT_SKIP_BP)
			e3:SetTargetRange(0,1)
			e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
			Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
		end
		if Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE then
			Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetCode(EFFECT_SKIP_M2)
			e3:SetTargetRange(0,1)
			e3:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
			Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
		end
		if Duel.GetCurrentPhase()==PHASE_MAIN2 then
			Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
			Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
		end
		if Duel.GetCurrentPhase()==PHASE_END then
			Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
		end
		Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,2)
		Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,2)
		Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,2)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_EP)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN)
	Duel.RegisterEffect(e2,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE_START,2)
	c:RegisterEffect(e1)
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function s.desfilter(c,tp)
	local type=bit.band(c:GetType(),TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	return Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,type)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local xg=c:GetOverlayGroup()
	local g=xg:Filter(s.desfilter,nil,tp)
	if chk==0 then
		if e:GetLabel()==100 then
			return g:GetCount()>0
		else return false end
	end
	local sg=g:FilterSelect(tp,s.desfilter,1,1,nil,tp)
	local type=bit.band(sg:GetFirst():GetType(),TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	Duel.SendtoGrave(sg,REASON_COST)
	e:SetLabel(type)
	local sg=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,type)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local type=e:GetLabel()
	if not type then type=TYPE_MONSTER end
	local sg=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,type)
	Duel.Destroy(sg,REASON_EFFECT,LOCATION_REMOVED)
end