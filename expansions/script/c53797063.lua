local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local sg=Group.CreateGroup()
		sg:KeepAlive()
		local ge0=Effect.GlobalEffect()
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_ADJUST)
		ge0:SetLabelObject(sg)
		ge0:SetOperation(s.geop)
		Duel.RegisterEffect(ge0,0)
	end
end
function s.chkfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_TOKEN) and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,c,c:GetCode())
end
function s.filter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity() and Duel.IsExistingMatchingCard(s.chkfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsOnField() and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetCategory(CATEGORY_NEGATE)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_CHAINING)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(s.discon)
		e1:SetCost(s.discost)
		e1:SetTarget(s.distg)
		e1:SetOperation(s.disop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
	end
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and rp~=tp
end
function s.costfilter(c)
	return c:IsType(TYPE_TOKEN) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,0,1,c,c:GetCode())
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,s.costfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,s.costfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function s.geop(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	local g=Duel.GetMatchingGroup(function(c)return c:GetType()&0x20002==0x20002 end,0,LOCATION_HAND,LOCATION_HAND,sg)
	if #g==0 then return end
	sg:Merge(g)
	local cp={}
	local f=Card.RegisterEffect
	Card.RegisterEffect=function(tc,te,bool)
		local pro1,pro2=te:GetProperty()
		if te:IsActivated() and te:GetCode()==EVENT_PHASE+PHASE_STANDBY and te:GetRange()&LOCATION_ONFIELD~=0 then table.insert(cp,te:Clone()) end
		return f(tc,te,bool)
	end
	for tc in aux.Next(g) do
		Duel.CreateToken(tp,tc:GetOriginalCode())
		for _,v in pairs(cp) do
			local e1=v:Clone()
			e1:SetDescription(aux.Stringid(id,0))
			e1:SetRange(LOCATION_HAND)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			f(tc,e1,true)
			local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(id)
			e2:SetRange(LOCATION_HAND)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetLabelObject(e1)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			f(tc,e2,true)
			local e3=Effect.CreateEffect(tc)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_ACTIVATE_COST)
			e3:SetRange(LOCATION_HAND)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetTargetRange(1,1)
			e3:SetCost(s.costchk)
			e3:SetOperation(s.costop)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			f(tc,e3,true)
			local e4=Effect.CreateEffect(tc)
			e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e4:SetCode(EVENT_CHAIN_SOLVED)
			e4:SetRange(LOCATION_HAND)
			e4:SetLabelObject(e1)
			e4:SetOperation(s.tfcon)
			e4:SetOperation(s.tfop)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			f(tc,e4,true)
		end
		cp={}
	end
	Card.RegisterEffect=f
end
function s.cfilter(c)
	return c:GetOriginalCode()==id and c:IsAbleToGraveAsCost()
end
function s.costchk(e,te_or_c,tp)
	return Duel.GetCurrentPhase()==PHASE_STANDBY and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_ACTION)
end
function s.tfcon(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function s.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetOperation(s.tdop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetOwner(),nil,2,REASON_EFFECT)
end
