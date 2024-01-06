local m=53760001
local cm=_G["c"..m]
cm.name="梦影浮现 绯红"
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
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_CUSTOM+m)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	SNNM.DressamAdjust(c)
	if not cm.global_check then
		cm.global_check=true
		local ge9=Effect.CreateEffect(c)
		ge9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge9:SetCode(EVENT_SUMMON_SUCCESS)
		ge9:SetOperation(cm.trop)
		Duel.RegisterEffect(ge9,0)
		local ge10=ge9:Clone()
		ge10:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge10,0)
	end
end
function cm.trop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	for tc in aux.Next(eg) do
		if tc:IsFaceup() and tc:IsType(TYPE_EFFECT) then
			if tc:IsSummonPlayer(0) then g1:AddCard(tc) else g2:AddCard(tc) end
		end
	end
	if #g1>0 then Duel.RaiseEvent(g1,EVENT_CUSTOM+m,re,r,rp,1,0) end
	if #g2>0 then Duel.RaiseEvent(g2,EVENT_CUSTOM+m,re,r,rp,0,0) end
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
	return SNNM.DressamLocCheck(tp,tp,1<<seq) and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0x9538,TYPES_TOKEN_MONSTER,2800,3200,1,RACE_FIEND,ATTRIBUTE_FIRE,POS_FACEUP,tp,0,1<<seq)
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
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then
		if c:GetFlagEffect(m)==0 then c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
		return c:GetFlagEffectLabel(m)&(1<<(tp+1))==0
	end
	c:SetFlagEffectLabel(m,1<<(tp+1))
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_NORMAL)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g==0 then return end
	local tc=g:GetFirst()
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		tc=g:Select(tp,1,1,nil):GetFirst()
	end
	if Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) then
		Duel.BreakEffect()
		local atk=tc:GetBaseAttack()
		if atk<0 then atk=0 end
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end
