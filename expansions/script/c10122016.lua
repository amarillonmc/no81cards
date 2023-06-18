--乌托兰深层 燃魂沙丘
local s,id = GetID()
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function s.initial_effect(c)
	local e1,e2,e3 = Scl_Utoland.FieldActivateEffects(c, id, nil, nil, s.minct, s.maxct, s.exop)
	local e4 = Scl_Utoland.DeepFieldGYEffect(c, id)
	if not s.counter then
	   s.counter = { [0] = 0, [1] = 0 }
	   local ge1=Effect.CreateEffect(c)
	   ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	   ge1:SetCode(EVENT_CHAINING)
	   ge1:SetOperation(s.ctop)
	   Duel.RegisterEffect(ge1,0)
	   local ge2=ge1:Clone()
	   ge2:SetCode(EVENT_CHAIN_NEGATED)
	   ge2:SetOperation(s.ctop2)
	   Duel.RegisterEffect(ge2,0)
	   local ge3=ge1:Clone()
	   ge3:SetCode(4179255)
	   ge3:SetOperation(s.ctop)
	   Duel.RegisterEffect(ge3,0)
	   local ge4=ge1:Clone()
	   ge4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	   ge4:SetOperation(s.ctop3)
	   Duel.RegisterEffect(ge4,0)
	end 
end
function s.minct(tp)
	return s.counter[tp] > 0 and 1 or 0
end
function s.maxct(tp)
	return s.counter[tp]
end
function s.exop(e,tp,res)
	if not res then return end
	Scl_Utoland.LinkSummon(tp)
end
function s.ctop3(e,tp,eg,ep,ev,re,r,rp)
	s.counter = { [0] = 0, [1] = 0 }
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local code1, code2 = Duel.GetChainInfo(ev, CHAININFO_TRIGGERING_CODE, CHAININFO_TRIGGERING_CODE2)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:GetHandler():IsType(TYPE_FIELD) or code1 == id or (code2 and code2 ==id) then return end
	s.counter[rp]=s.counter[rp]+1
end
function s.ctop2(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:GetHandler():IsType(TYPE_FIELD) then return end
	s.counter[rp]=s.counter[rp]-1
end
