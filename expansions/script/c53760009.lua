local m=53760009
local cm=_G["c"..m]
cm.name="梦影浮现 留绀"
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
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e3:SetCountLimit(1)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.target)
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
	return SNNM.DressamLocCheck(tp,tp,1<<seq) and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0x9538,TYPES_TOKEN_MONSTER,2600,3600,5,RACE_FIEND,ATTRIBUTE_WIND,POS_FACEUP,tp,0,1<<seq)
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
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsType,1,nil,TYPE_NORMAL) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsType,1,1,nil,TYPE_NORMAL)
	Duel.Release(g,REASON_COST)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_EFFECT)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_NORMAL)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local ct=Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) and 2 or 1
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,0,LOCATION_MZONE,1,ct,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
