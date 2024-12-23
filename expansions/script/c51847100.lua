--幽火军团·暗杀者
local eev
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,3,s.mfilter,aux.Stringid(id,0),2,s.altop)
	c:EnableReviveLimit()
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.chk)
		Duel.RegisterEffect(ge1,0)
	end
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetCost(s.spcost)
	c:RegisterEffect(e1)
	--Disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.chcon)
	e3:SetCost(s.chcon)
	e3:SetTarget(s.chtg)
	e3:SetOperation(s.chop)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(TIMING_DAMAGE_STEP)
	e4:SetCountLimit(1)
	e4:SetCondition(aux.dscon)
	e4:SetOperation(s.atkop)
	c:RegisterEffect(e4)

end
function s.chkfilter(c,tp)
	return c:IsSummonPlayer(1-tp)
end
function s.chk(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local tc=eg:GetFirst()
		while tc do
			if s.chkfilter(tc,p) then
				Duel.RegisterFlagEffect(p,id,RESET_PHASE+PHASE_END,0,1)
			end
			tc=eg:GetNext() 
		end
		if Duel.GetFlagEffect(p,id)>4 then
			Duel.RegisterFlagEffect(p,id+o,RESET_PHASE+PHASE_END,0,2)
		end
	end
end
function s.spcost(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_XYZ)~=SUMMON_TYPE_XYZ then return true end
	return Duel.GetTurnPlayer()~=tp
end
function s.exxyzfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xa67)
end
function s.mfilter(c,e,tp)
	local g=Duel.GetMatchingGroup(s.exxyzfilter,tp,LOCATION_MZONE,0,nil)
	return g and #g>0 and g:IsContains(c)
end
function s.altop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id+o)>0 end
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	eev=ev
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.disop)
	e:SetLabelObject(re:GetLabelObject())
	local op=re:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end

end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if eev<=1 then eev=2 end
	local te=Duel.GetChainInfo(eev-1,CHAININFO_TRIGGERING_EFFECT)
	if Duel.NegateEffect(eev-1) and te:GetHandler():IsRelateToEffect(te) then
		Duel.Destroy(te:GetHandler(),REASON_EFFECT)
	end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
