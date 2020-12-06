--劳改
function c33710906.initial_effect(c)
   --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	---
	if not c33710906.global_check then
		c33710906.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c33710906.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CHAINING)
		ge3:SetOperation(c33710906.checkop2)
		Duel.RegisterEffect(ge3,0)
	end
	--changemonster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33710906,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,33710906)
	e1:SetCondition(c33710906.con1)
	e1:SetOperation(c33710906.op1)
	c:RegisterEffect(e1)  
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--changetrap
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,33710907)
	e3:SetCondition(c33710906.con2)
	e3:SetOperation(c33710906.op2)
	c:RegisterEffect(e3)
	--changeSpell
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,33710908)
	e4:SetCondition(c33710906.con3)
	e4:SetOperation(c33710906.op3)
	c:RegisterEffect(e4)
end
function c33710906.monfil(c)
	return c:GetSummonPlayer()==Duel.GetTurnPlayer()
end
function c33710906.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c33710906.monfil,nil)
	if g:GetCount()>0 then Duel.RegisterFlagEffect(Duel.GetTurnPlayer(),33710906,RESET_PHASE+PHASE_END,0,1) end
end
function c33710906.checkop2(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.RegisterFlagEffect(re:GetHandler():GetControler(),33710907,RESET_PHASE+PHASE_END,0,1)
	end
	if re:GetHandler():IsType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.RegisterFlagEffect(re:GetHandler():GetControler(),33710908,RESET_PHASE+PHASE_END,0,1)
	end
end
function c33710906.prfilter(c)
	return c:IsFaceup() and c:IsCode(33710906)
end
function c33710906.con1(e,tp,eg)
	local g=eg:Filter(c33710906.monfil,nil)
	return g:GetCount()>0 and Duel.GetFlagEffect(Duel.GetTurnPlayer,33710906)==0 and Duel.GetMatchingGroupCount(c33710906.prfilter,tp,LOCATION_ONFIELD,0,nil)>0
end
function c33710906.op1(e,tp,eg)
	local g=eg:Filter(c33710906.monfil,nil) 
	for tc in aux.Next(g) do
		tc:ReplaceEffect(33710924, RESET_EVENT + RESETS_STANDARD)
	end
end
function c33710906.con2(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetFlagEffect(Duel.GetTurnPlayer,33710907)==0 and Duel.GetMatchingGroupCount(c33710906.prfilter,tp,LOCATION_ONFIELD,0,nil)>1
end
function c33710906.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c33710906.repop)
end
function c33710906.con3(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetFlagEffect(Duel.GetTurnPlayer,33710908)==0 and Duel.GetMatchingGroupCount(c33710906.prfilter,tp,LOCATION_ONFIELD,0,nil)>2
end
function c33710906.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c33710906.repop)
end
function c33710906.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,2000,REASON_EFFECT)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end