--花幻-「连」
if not c71401001 then dofile("expansions/script/c71401001.lua") end
function c71401021.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c71401021.mfilter,aux.NonTuner(c71401021.mfilter),1)
	c:EnableReviveLimit()
	--Fissure
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(c71401021.rmtarget)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1)
	--Gravekeeper's Servant
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_FIELD)
	e1a:SetCode(81674782)
	e1a:SetRange(LOCATION_SZONE)
	e1a:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1a:SetTargetRange(0xff,0xff)
	e1a:SetTarget(c71401021.checktg)
	c:RegisterEffect(e1a)
	--disable
	local e1b=Effect.CreateEffect(c)
	e1b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1b:SetCode(EVENT_CHAIN_SOLVING)
	e1b:SetRange(LOCATION_MZONE)
	e1b:SetCondition(c71401021.discon)
	e1b:SetOperation(c71401021.disop)
	c:RegisterEffect(e1b)
	--place
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71401001,2))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_EQUIP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,71401021)
	e2:SetCost(yume.ButterflyLimitCost)
	e2:SetTarget(yume.ButterflyPlaceTg)
	e2:SetOperation(c71401021.op2)
	c:RegisterEffect(e2)
	--cannot activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71401021,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,71501021)
	e3:SetCondition(c71401021.con3)
	e3:SetCost(yume.ButterflyLimitCost)
	e3:SetTarget(c71401021.tg3)
	e3:SetOperation(c71401021.op3)
	c:RegisterEffect(e3)
	yume.ButterflyCounter()
end
c71401021.material_type=TYPE_SYNCHRO
function c71401021.mfilter(c)
	return not c:IsSynchroType(TYPE_SYNCHRO) and c:IsRace(RACE_SPELLCASTER)
end
function c71401021.rmtarget(e,c)
	return c:IsLocation(0x80) or not c:IsType(TYPE_MONSTER)
end
function c71401021.checktg(e,c)
	return not c:IsPublic()
end
function c71401021.discon(e,tp,eg,ep,ev,re,r,rp)
	local code=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE)
	return e:GetHandler():IsDefensePos()
		and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsExistingMatchingCard(Card.IsCode,0,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,code)
end
function c71401021.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c71401021.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			c:RegisterEffect(e1)
			local ct=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
			local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
			if ct==0 or g:GetCount()<ct then return end
			local bg=Group.FromCards(g:GetFirst())
			for i=2,ct do
				bg:AddCard(g:GetNext())
			end
			if bg:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN,REASON_EFFECT)==ct and Duel.SelectYesNo(tp,aux.Stringid(71401021,0)) then
				Duel.BreakEffect()
				Duel.DisableShuffleCheck()
				if Duel.Remove(bg,POS_FACEDOWN,REASON_EFFECT)==0 then return end
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
				e2:SetValue(c71401021.tglimit)
				e2:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e2,tp)
			end
		end
	end
end
function c71401021.tglimit(e,re,rp)
	return true
	--return Duel.IsExistingMatchingCard(Card.IsCode,0,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,re:GetHandler():GetCode())
end
function c71401021.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c71401021.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if chk==0 then
		local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
		if ct==0 or g:GetCount()<ct then return false end
		local bg=Group.FromCards(g:GetFirst())
		for i=2,ct do
			bg:AddCard(g:GetNext())
		end
		return bg:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN,REASON_EFFECT)==ct
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,ct,tp,LOCATION_DECK)
end
function c71401021.op3(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if ct==0 or g:GetCount()<ct then return end
	local bg=Group.FromCards(g:GetFirst())
	for i=2,ct do
		bg:AddCard(g:GetNext())
	end
	Duel.DisableShuffleCheck()
	if Duel.Remove(bg,POS_FACEDOWN,REASON_EFFECT)==0 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetValue(c71401021.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c71401021.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsOnField()
		--and not Duel.IsExistingMatchingCard(Card.IsCode,0,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,rc:GetCode())
end