--惊乐大欢迎
local s,id,o=GetID()
function s.initial_effect(c)
	s.effect_check={}
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CUSTOM+id)
	--e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_DECK)
	e2:SetCost(s.cost)
	--e2:SetCondition(s.chaincon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetRange(LOCATION_DECK)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetLabelObject(e2)
	e3:SetTargetRange(1,0)
	e3:SetTarget(s.actarget)
	e3:SetOperation(s.costop)
	c:RegisterEffect(e3)
	--act qp/trap in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,2))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetTargetRange(LOCATION_HAND,0)
	e0:SetRange(LOCATION_DECK)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x15c))
	e0:SetCost(s.actcost)
	e0:SetValue(id)
	c:RegisterEffect(e0)
	if not s.global_effect then
		s.activate_sequence={}
		local ge0=Effect.CreateEffect(c)
		ge0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge0:SetOperation(s.geop)
		Duel.RegisterEffect(ge0,0)
		local _GetActivateLocation=Effect.GetActivateLocation
		local _GetActivateSequence=Effect.GetActivateSequence
		local _NegateActivation=Duel.NegateActivation
		function Effect.GetActivateLocation(e)
			if e:GetDescription()==aux.Stringid(id,1) then
				return _GetActivateLocation(e)
			end
			return _GetActivateLocation(e)
		end
		function Effect.GetActivateSequence(e)
			if e:GetDescription()==aux.Stringid(id,1) then
				return s.activate_sequence[e]
			end
			return _GetActivateSequence(e)
		end
		function Duel.NegateActivation(ev)
			local re=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
			local res=_NegateActivation(ev)
			if res and aux.GetValueType(re)=="Effect" then
				local rc=re:GetHandler()
				if rc and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) and re:GetDescription()==aux.Stringid(id,1) then
					rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
				end
			end
			return res
		end
	end
end
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function s.actarget(e,te,tp)
	return te:GetHandler()==e:GetHandler() and te==e:GetLabelObject()
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	s.activate_sequence[te]=c:GetSequence()
	e:GetHandler():CreateEffectRelation(te)
	c:CancelToGrave(false)
	local te2=te:Clone()
	e:SetLabelObject(te2)
	te:SetType(26)
	c:RegisterEffect(te2,true)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(s.rsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function s.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
	end
	re:Reset()
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END and Duel.GetCurrentChain()==0
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END and Duel.GetCurrentChain()==0 and Duel.GetTurnPlayer()==1-tp
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local res=true
		if KOISHI_CHECK and s[tp] and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			res=s[tp]:GetActivateEffect():IsActivatable(tp,true)
		else
			res=(c:CheckActivateEffect(false,false,false)~=nil)
		end
		return res and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end
end
function s.geop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	s[0]=Duel.CreateToken(0,id)
	s[1]=Duel.CreateToken(1,id)
	if KOISHI_CHECK then
		s[0]:SetCardData(CARDDATA_TYPE,TYPE_TRAP)
		s[1]:SetCardData(CARDDATA_TYPE,TYPE_TRAP)
	end
	e:Reset()
end
function s.acttg(e,c)
	return c:IsType(TYPE_TRAP) and c:IsSetCard(0x15c)
end
--[[function s.actcon(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return c:GetActivateEffect():IsActivatable(tp,true,true) and c:CheckActivateEffect(false,false,false)~=nil
end
function s.acttg2(e,c)
	if s.global_check~=0 and not (c:IsType(TYPE_TRAP) and c:IsSetCard(0x15c) and c:IsHasEffect(id)) then return end
	s.global_check=1
	local ae={c:IsHasEffect(id)}
	local boolean=false
	for i=1,#ae do
		local ac=ae[i]:GetHandler()
		if ac and aux.GetValueType(ac)=="Card" then
			boolean=(ac:GetActivateEffect():IsActivatable(tp,true,true) and ac:CheckActivateEffect(false,false,false)~=nil)
		end
	end
	s.global_check=0
	return boolean
end]]
function s.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetActivateEffect():IsActivatable(tp,true,false) and c:CheckActivateEffect(false,false,false)~=nil end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetOperation(s.chainop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	if re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_TRAP) and c:IsSetCard(0x15c) and ep==tp then
		--s.effect_check[re]=1
		--s.effect_check[re]=tp+(10*Duel.GetTurnCount())
		--Debug.Message(tp+(100*Duel.GetTurnCount()))
		--Duel.RegisterFlagEffect(tp,id+re:GetFieldID()+c:GetFieldID(),0,0,1)
		Duel.RaiseEvent(c,EVENT_CUSTOM+id,re,0,tp,tp,0)
		Duel.SetChainLimit(s.chainlm)
		--Debug.Message("0")
	end
end
function s.chainlm(e,rp,tp)
	return e:GetDescription()==(aux.Stringid(id,1))
end
function s.chaincon(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	local ct=tp+10*Duel.GetTurnCount()
	Debug.Message(ct)
	if not s.effect_check[re] then return false end
	local _,ct2=s.effect_check[re]
		Debug.Message("114515")
	Debug.Message(_)
		Debug.Message("114516")
	Debug.Message(ct2)
	return re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) 
	and ct2==ct
--and Duel.GetFlagEffect(tp,id+re:GetFieldID()+(re:GetHandler()):GetFieldID())~=0
end
function s.filter(c)
	return c:IsCode(31600845) and c:IsAbleToHand()
end
function s.thfilter(c,tp)
	return c:IsCode(31600845) and c:IsAbleToHand() and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,c)
end
function s.tgfilter(c)
	return c:IsSetCard(0x15b) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function s.ssfilter(c,e,tp)
	return c:IsSetCard(0x15b) and (c:IsSummonable(true,nil) or (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetTurnPlayer()==tp then
		if chk==0 then return 
		--Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) and 
		Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	else
		if chk==0 then return (Duel.IsPlayerCanSpecialSummon(tp) or Duel.IsPlayerCanSummon(tp)) and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_SUMMON+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
		Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	if Duel.GetTurnPlayer()==tp then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,s.ssfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			if tc:IsSummonable(true,nil) and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))==0) then
				Duel.Summon(tp,tc,true,nil)
			else
				Duel.SpecialSummon(tc,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
