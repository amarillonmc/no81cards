--战吼的岩城
local s,id,o=GetID()
function s.initial_effect(c)
	--c:SetCardData(CARDDATA_TYPE,TYPE_SPELL+TYPE_FIELD+TYPE_QUICKPLAY)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetRange(LOCATION_HAND)
	e0:SetHintTiming(TIMING_BATTLE_PHASE+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e0:SetCondition(s.condition)
	c:RegisterEffect(e0)
	local Effect_IsHasType=Effect.IsHasType
	function Effect.IsHasType(e,type)
		if e==e0 and type==EFFECT_TYPE_ACTIVATE then return true end
		if e==e0 and type==EFFECT_TYPE_QUICK_O then return false end
		return Effect_IsHasType(e,type)
	end
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(s.indcon)
	e2:SetTarget(s.indtg)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	--attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(s.atkcon)
	e4:SetTarget(s.atktg)
	e4:SetOperation(s.atkop)
	c:RegisterEffect(e4)
	--
	if not s.globle_check then
		s.globle_check=true
		--[[local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD)
		ge0:SetCode(EFFECT_ACTIVATE_COST)
		ge0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetCost(aux.FALSE)
		ge0:SetTargetRange(1,1)
		ge0:SetTarget(s.actarget)
		Duel.RegisterEffect(ge0,0)]]
		--Activate to field
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_ACTIVATE_COST)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetTargetRange(1,0)
		ge1:SetTarget(s.actarget2)
		ge1:SetOperation(s.costop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
	end
end
function s.actarget(e,te,tp)
	--prevent activating
	return e:GetValue()==id
end
function s.actarget2(e,te,tp)
	local tc=te:GetHandler()
	if tc:GetOriginalCode()==id and te:IsHasType(EFFECT_TYPE_QUICK_O) and tc:IsLocation(LOCATION_HAND) and tc:IsType(TYPE_SPELL) then
		--Debug.Message("0")
		e:SetLabelObject(te)
		return true
	end
	return false
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	local tp=te:GetHandlerPlayer()
	--local te2=te:Clone()
	--tc:RegisterEffect(te2)
	--te2:UseCountLimit(tp)
	--te:SetValue(id)
	--te:SetType(EFFECT_TYPE_ACTIVATE)
	if tc:IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,false)
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	end
	--[[local ge3=Effect.CreateEffect(tc)
	ge3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	ge3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	ge3:SetCode(EVENT_CHAIN_SOLVED)
	ge3:SetLabelObject(te)
	ge3:SetReset(RESET_EVENT+RESET_CHAIN)
	ge3:SetOperation(s.resetop)
	Duel.RegisterEffect(ge3,tp)
	local ge4=ge3:Clone()
	ge4:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(ge4,tp)]]
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	if re==e:GetLabelObject() and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		e:Reset()
		re:Reset()
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return --Duel.GetTurnPlayer()==tp and 
		 ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
		 and Duel.GetCurrentChain()==0
end
function s.thfilter(c)
	return c:IsSetCard(0x15f) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		if sg:GetCount()>0 and Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 and sg:GetFirst():IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			Duel.BreakEffect()
			Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		end
	end
end
function s.indcon(e)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function s.indtg(e,c)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function s.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevelAbove(5)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
