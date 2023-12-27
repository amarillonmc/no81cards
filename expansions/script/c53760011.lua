local m=53760011
local cm=_G["c"..m]
cm.name="梦影浮现 漆黑"
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	aux.AddSetNameMonsterList(c,0x9538)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(cm.adjustop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e3:SetCountLimit(1)
	e3:SetCost(cm.cost)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	if not Doremy_Adjust then
		Doremy_Adjust=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_SUMMON_COST)
		ge1:SetTargetRange(0xff,0xff)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge1:SetCode(EFFECT_SPSUMMON_COST)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_SUMMON_SUCCESS)
		ge3:SetOperation(cm.sreset)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge3:Clone()
		ge4:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge4,0)
		local ge5=ge3:Clone()
		ge5:SetCode(EVENT_SUMMON_NEGATED)
		Duel.RegisterEffect(ge5,0)
		local ge6=ge3:Clone()
		ge6:SetCode(EVENT_SPSUMMON_NEGATED)
		Duel.RegisterEffect(ge6,0)
		local ge7=Effect.CreateEffect(c)
		ge7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge7:SetCode(EVENT_CHAIN_SOLVING)
		ge7:SetOperation(cm.count)
		Duel.RegisterEffect(ge7,0)
		local ge8=Effect.CreateEffect(c)
		ge8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge8:SetCode(EVENT_CHAIN_SOLVED)
		ge8:SetOperation(cm.creset)
		Duel.RegisterEffect(ge8,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Doremy_Token_Check then return end
	Doremy_Summoning_Check=true
end
function cm.sreset(e,tp,eg,ep,ev,re,r,rp)
	if Doremy_Token_Check then return end
	Doremy_Summoning_Check=false
end
function cm.count(e,tp,eg,ep,ev,re,r,rp)
	Doremy_Chain_Solving_Check=true
end
function cm.creset(e,tp,eg,ep,ev,re,r,rp)
	Doremy_Chain_Solving_Check=false
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	local seq=c:GetSequence()
	if (Doremy_Summoning_Check or Doremy_Chain_Solving_Check or Doremy_Token_Check) or not (cm.spcheck(tp,seq) or cm.spcheck(1-tp,4-seq)) or ((ph==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or ph==PHASE_DAMAGE_CAL) or c:GetFlagEffect(m+50)>0 then return end
	Duel.HintSelection(Group.FromCards(c))
	cm.sp(c,tp,c:GetSequence())
	cm.sp(c,1-tp,4-c:GetSequence())
	Duel.SpecialSummonComplete()
	c:RegisterFlagEffect(m+50,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
end
function cm.spcheck(tp,seq)
	return SNNM.DressamLocCheck(tp,tp,1<<seq) and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0x9538,TYPES_TOKEN_MONSTER,2300,3900,6,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP,tp,0,1<<seq)
end
function cm.sp(c,tp,seq)
	if cm.spcheck(tp,seq) then
		Doremy_Token_Check=true
		local token=Duel.CreateToken(tp,m+1)
		local b=SNNM.DressamSPStep(token,tp,tp,POS_FACEUP,1<<seq)
		if b then
			c:CreateRelation(token,RESET_EVENT+RESETS_STANDARD)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_SELF_DESTROY)
			e1:SetLabelObject(c)
			e1:SetCondition(cm.descon)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1)
		end
		Doremy_Token_Check=false
	end
end
function cm.descon(e)
	local c,tc=e:GetHandler(),e:GetLabelObject()
	return not (c:GetColumnGroup():IsContains(tc) and tc:IsRelateToCard(c)) or tc:IsFacedown()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(REASON_COST,tp,Card.IsType,1,nil,TYPE_NORMAL) end
	local g=Duel.SelectReleaseGroup(REASON_COST,tp,Card.IsType,1,1,nil,TYPE_NORMAL)
	Duel.Release(g,REASON_COST)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_NORMAL)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetTarget(cm.rmtarget)
	e1:SetTargetRange(0xfe,0xff)
	e1:SetValue(LOCATION_REMOVED)
	if Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) then
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
		e2:SetLabel(Duel.GetTurnCount())
		e2:SetLabelObject(e1)
		e2:SetCondition(cm.con)
		e2:SetOperation(cm.op)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
	else
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.rmtarget(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer() and not c:IsLocation(0x80) and not c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_EFFECT)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():Reset()
	e:Reset()
end
