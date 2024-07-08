--异兽秘异三变联体
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,s.ffilter,2,true)
	--change effect type
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetCode(id)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(1,0)
	e0:SetCondition(s.condition)
	c:RegisterEffect(e0)
	--activate from hand
	local e01=Effect.CreateEffect(c)
	e01:SetDescription(aux.Stringid(id,2))
	e01:SetType(EFFECT_TYPE_FIELD)
	e01:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e01:SetRange(LOCATION_MZONE)
	e01:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x157))
	e01:SetTargetRange(LOCATION_HAND,0)
	e01:SetCondition(s.condition)
	e01:SetValue(id)
	c:RegisterEffect(e01)
	local e02=e01:Clone()
	e02:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e02)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	--
	if not s.globle_check then
		s.globle_check=true
		Myutant_BlackLotus_qta_array={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_ACTIVATE_COST)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetCost(s.costchk)
		ge1:SetTargetRange(1,0)
		ge1:SetTarget(s.actarget)
		ge1:SetOperation(s.costop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
		--
		local g=Duel.GetMatchingGroup(s.actfilter,0,0xff,0xff,nil)
		for tc in aux.Next(g) do
			local te=tc:GetActivateEffect()
			local te2=te:Clone()
			te2:SetType(EFFECT_TYPE_QUICK_O)
			te2:SetCode(EVENT_FREE_CHAIN)
			te2:SetRange(LOCATION_HAND)
			te2:SetHintTiming(0,TIMING_MAIN_END)
			tc:RegisterEffect(te2)
			Myutant_BlackLotus_qta_array[#Myutant_BlackLotus_qta_array+1]=te2
		end
		--
		local Effect_IsHasType=Effect.IsHasType
		function Effect.IsHasType(e,type)
			if s.in_array(e,Myutant_BlackLotus_qta_array) then 
				if type==EFFECT_TYPE_ACTIVATE then
					return true 
				elseif type==EFFECT_TYPE_QUICK_O then
					return false
				end
			end
			return Effect_IsHasType(e,type)
		end
	end
end
function s.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x157) and (not sg or sg:FilterCount(aux.TRUE,c)==0 or sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp
		or Duel.GetTurnPlayer()==e:GetHandlerPlayer() 
		then return false end
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function s.costfilter(c)
	return c:IsAbleToRemoveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		e:SetLabel(100)
		return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cost=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,3,nil)
	local typ=0
	local tc=cost:GetFirst()
	while tc do
		typ=bit.bor(typ,bit.band(tc:GetOriginalType(),0x7))
		tc=cost:GetNext()
	end
	e:SetLabel(typ)
	Duel.Remove(cost,POS_FACEUP,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return true
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local typ=e:GetLabel()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(s.efilter)
		e1:SetLabel(typ)
		c:RegisterEffect(e1)
		if bit.band(typ,TYPE_MONSTER)~=0 then
			c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
		end
		if bit.band(typ,TYPE_SPELL)~=0 then
			c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4))
		end
		if bit.band(typ,TYPE_TRAP)~=0 then
			c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,5))
		end
	end
end
function s.efilter(e,te)
	return te:GetHandler():GetOriginalType()&e:GetLabel()~=0 and te:GetOwner()~=e:GetOwner()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function s.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x157) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

---------------------------------------------------------------

function s.in_array(b,list)
  if not list then
	return false 
  end 
  if list then
	for _,ct in pairs(list) do
	  if ct==b then return true end
	end
  end
  return false
end 
function s.actfilter(c)
	return c:IsSetCard(0x157) and c:IsType(TYPE_SPELL) and not c:IsType(TYPE_QUICKPLAY) 
end
function s.costchk(e,te_or_c,tp)
	if Duel.GetTurnPlayer()==tp then return false end
	local ph=Duel.GetCurrentPhase()
	local b1=ph==PHASE_MAIN1 or ph==PHASE_MAIN2
	local b2=e:GetHandler():IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)
	local b3=Duel.GetCurrentChain()==0
	return Duel.IsPlayerAffectedByEffect(tp,id) and b1 and b2 and b3
end
function s.actarget(e,te,tp)
	local tc=te:GetHandler()
	if s.in_array(te,Myutant_BlackLotus_qta_array) and tc:IsSetCard(0x157) and tc:IsLocation(LOCATION_HAND) and tc:IsType(TYPE_SPELL) then
		e:SetLabelObject(te)
		return true
	end
	return false
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	local tp=te:GetHandlerPlayer()
	if tc:IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,false)
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
		if not tc:IsType(TYPE_CONTINUOUS) then
			tc:CancelToGrave(false)
		end
	end
end
