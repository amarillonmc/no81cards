--Confusione Totale - Ritiro
--Scripted by: XGlitchy30

local s,id=GetID()

xpcall(function() require("expansions/script/glitchylib_vsnemo") end,function() require("script/glitchylib_vsnemo") end)

function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	e1:SetHintTiming(TIMING_END_PHASE,0)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_HAND)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local ct=eg:FilterCount(s.cfilter,nil,p)
		if ct>0 then
			for i=1,ct do
				Duel.RegisterFlagEffect(p,id,RESET_PHASE+PHASE_END,0,1)
			end
		end
	end
	
	if Duel.GetFlagEffect(tp,id+100)<=0 then
		Duel.RegisterFlagEffect(tp,id+100,RESET_PHASE+PHASE_END,0,1,0)
	end
	local saved_levels = Duel.GetFlagEffectLabel(tp,id+100)
	local incr_lv=0
	for tc in aux.Next(eg) do
		if tc:HasLevel() then
			local lv=tc:GetLevel()
			if saved_levels&(2^lv)==0 and incr_lv&(2^lv)==0 then
				incr_lv = incr_lv + (2^lv)
			end
		end
	end
	Duel.UpdateFlagEffectLabel(tp,id+100,incr_lv)
end

function s.condition(e,tp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_END and Duel.GetFlagEffect(1-tp,id)>=2
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(1-tp,id)<2 then return false end
	local c=e:GetHandler()
	local rct = Duel.GetTurnPlayer()~=tp and 1 or 2
	local saved_levels = Duel.GetFlagEffectLabel(tp,id+100)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_ALL,LOCATION_ALL)
	e1:SetTarget(s.distg)
	e1:SetLabel(saved_levels)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,rct)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(0,1)
	e2:SetValue(s.aclimit)
	e2:SetLabel(saved_levels)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,rct)
	Duel.RegisterEffect(e2,tp)
	--
	if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		local lp=Duel.GetLP(tp)
		Duel.SetLP(tp,math.ceil(lp/2))
		if math.abs(Duel.GetLP(tp)*2 - lp)<=1 then
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(aux.Stringid(id,3))
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e3:SetCode(EVENT_TO_GRAVE)
			e3:SetCondition(s.damcon)
			e3:SetOperation(s.damop)
			e3:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,rct)
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function s.distg(e,c)
	local saved_levels = e:GetLabel()
	return c:HasLevel() and saved_levels&(2^c:GetLevel())~=0
end
function s.aclimit(e,re,tp)
	local saved_levels = e:GetLabel()
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc and rc:HasLevel() and saved_levels&(2^rc:GetLevel())~=0
end

function s.df(c,tp)
	return c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.df,1,nil,tp)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local ct=eg:FilterCount(s.df,nil,tp)
	Duel.Damage(1-tp,ct*1000,REASON_EFFECT)
end