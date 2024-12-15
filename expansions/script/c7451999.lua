--巴别塔
local s,id,o=GetID()
function s.initial_effect(c)
	if c:GetOriginalCodeRule()==7451999 then
		--Activate
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_ACTIVATE)
		e1:SetCode(EVENT_FREE_CHAIN)
		c:RegisterEffect(e1)
		--Debug.Message("03")
		--
		Star_universe_monster_effect_table={}
		Star_universe_field_effect_table={}
		--gain tp
		local ct=Duel.GetFieldGroupCount(0,0,LOCATION_DECK)
		local ct2=Duel.GetFieldGroupCount(0,LOCATION_EXTRA,0)
		local tp=0
		if ct>0 or ct2>0 then tp=1 end
		--
		if s[tp] and s[tp]==1 then return end
		s[tp]=1
		--move to field
		if Duel.DisableActionCheck then
			--to field
			local move=(function()
				local ct=Duel.GetFieldGroupCount(0,0,LOCATION_DECK)
				local ct2=Duel.GetFieldGroupCount(0,LOCATION_EXTRA,0)
				local tp=0
				if ct>0 or ct2>0
				then tp=1 end
				local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
				if fc then
					Duel.SendtoGrave(fc,REASON_RULE)
					Duel.BreakEffect()
				end
				Duel.DisableShuffleCheck()
				Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,false)
			end)
			Duel.DisableActionCheck(true)
			pcall(move)
			Duel.DisableActionCheck(false)
		else
			--Activate
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_QUICK_O)
			e1:SetCode(EVENT_FREE_CHAIN)
			e1:SetRange(LOCATION_HAND)
			e1:SetHintTiming(TIMING_DRAW_PHASE+TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetRange(LOCATION_DECK)
			e2:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
			c:RegisterEffect(e2)
			--activate cost
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_ACTIVATE_COST)
			e4:SetRange(LOCATION_DECK+LOCATION_HAND)
			e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
			e4:SetTargetRange(1,0)
			e4:SetTarget(s.costtg)
			e4:SetOperation(s.costop)
			c:RegisterEffect(e4)
		end
		--adjust
		local e01=Effect.CreateEffect(c)
		e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e01:SetCode(EVENT_ADJUST)
		e01:SetOperation(s.adjustop)
		Duel.RegisterEffect(e01,tp)
		--
	else
		if c:IsType(TYPE_MONSTER) then
			--activate
			local e8=Effect.CreateEffect(c)
			e8:SetDescription(aux.Stringid(id,0))
			e8:SetType(EFFECT_TYPE_QUICK_O)
			e8:SetCode(EVENT_FREE_CHAIN)
			e8:SetRange(LOCATION_HAND)
			e8:SetCost(s.actcost)
			e8:SetTarget(s.acttg)
			e8:SetOperation(s.actop)
			c:RegisterEffect(e8)
			--special summon
			local e0=Effect.CreateEffect(c)
			e0:SetDescription(aux.Stringid(id,1))
			e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e0:SetType(EFFECT_TYPE_IGNITION)
			e0:SetRange(LOCATION_REMOVED)
			e0:SetCost(s.cost)
			e0:SetTarget(s.target)
			e0:SetOperation(s.operation)
			c:RegisterEffect(e0)
			--spsummon
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(id,1))
			e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
			e1:SetCode(EVENT_SUMMON_SUCCESS)
			e1:SetRange(LOCATION_REMOVED)
			e1:SetProperty(EFFECT_FLAG_DELAY)
			e1:SetCondition(s.spcon)
			e1:SetCost(s.cost)
			e1:SetTarget(s.target)
			e1:SetOperation(s.operation)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EVENT_SPSUMMON_SUCCESS)
			c:RegisterEffect(e2)
			--original effect gain
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_SUMMON_SUCCESS)
			e3:SetOperation(s.oegop)
			c:RegisterEffect(e3)
			local e4=e3:Clone()
			e4:SetCode(EVENT_SPSUMMON_SUCCESS)
			c:RegisterEffect(e4)
			local e5=e3:Clone()
			e5:SetCode(EVENT_FLIP)
			c:RegisterEffect(e5)
		elseif c:IsType(TYPE_FIELD) then
			--Debug.Message(c:GetOriginalCode())
			--Debug.Message("05")
			--Activate
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_ACTIVATE)
			e1:SetCode(EVENT_FREE_CHAIN)
			c:RegisterEffect(e1)
			--spsummon
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(id,2))
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
			e2:SetProperty(EFFECT_FLAG_DELAY)
			e2:SetCode(EVENT_TO_HAND)
			e2:SetTarget(s.rthatg)
			e2:SetOperation(s.rthaop)
			c:RegisterEffect(e2)
			--cannot be target
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetRange(LOCATION_FZONE)
			e3:SetTargetRange(LOCATION_MZONE,0)
			e3:SetTarget(aux.TRUE)
			e3:SetValue(aux.tgoval)
			c:RegisterEffect(e3)
		end
	end
end
function s.costtg(e,te,tp)
	local tc=te:GetHandler()
	e:SetLabelObject(te)
	return tc==e:GetHandler() and te:IsHasType(EFFECT_TYPE_QUICK_O) and (tc:IsLocation(LOCATION_HAND) or tc:IsLocation(LOCATION_DECK))
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	local tp=te:GetHandlerPlayer()
	te:SetType(EFFECT_TYPE_ACTIVATE)
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
	local ge3=Effect.CreateEffect(tc)
	ge3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	ge3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	ge3:SetCode(EVENT_CHAIN_SOLVED)
	ge3:SetLabelObject(te)
	ge3:SetReset(RESET_PHASE+PHASE_END)
	ge3:SetOperation(s.resetop)
	Duel.RegisterEffect(ge3,tp)
	local ge4=ge3:Clone()
	ge4:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(ge4,tp)
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	if re==e:GetLabelObject() and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		re:SetType(EFFECT_TYPE_QUICK_O)
		e:Reset()
	end
end

-------------------------------Effect_Change-----------------------------------

function s.cefilter(c)
	return (c:IsType(TYPE_MONSTER) or c:IsType(TYPE_FIELD)) and not c:IsCode(7451999)
end
function s.aefilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(7451999)
end
function s.mactarget(e,te,tp)
	return Star_universe_monster_effect_table[te:GetFieldID()]==1999 and not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_FZONE,0,1,nil)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	local c=e:GetOwner()
	--
	local ge0=Effect.CreateEffect(c)
	ge0:SetType(EFFECT_TYPE_FIELD)
	ge0:SetCode(EFFECT_ACTIVATE_COST)
	ge0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	ge0:SetCost(aux.FALSE)
	ge0:SetTargetRange(1,1)
	ge0:SetTarget(s.mactarget)
	Duel.RegisterEffect(ge0,tp)
	--
	local ceg=Duel.GetMatchingGroup(s.cefilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	for tc in aux.Next(ceg) do
		--Debug.Message("0")
		local ce=s.field_gettableeffect(c,tc:GetOriginalCode())
		tc:ReplaceEffect(7451999,0)
		if not tc:IsType(TYPE_EFFECT) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetValue(TYPE_EFFECT)
			tc:RegisterEffect(e1,true)
		end
	end
	local aeg=Duel.GetMatchingGroup(s.aefilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	for tc in aux.Next(aeg) do
		--tohand
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,3))
		e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetRange(LOCATION_GRAVE)
		e2:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
		if tc:IsType(TYPE_SPELL) then
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
			e2:SetCode(EVENT_PHASE+PHASE_END)
		end
		e2:SetCondition(s.thcon)
		e2:SetCost(s.thcost)
		e2:SetTarget(s.thtg)
		e2:SetOperation(s.thop)
		tc:RegisterEffect(e2)
	end
	e:Reset()
end
function s.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

-------------------------------Monster_Effect-----------------------------------

function s.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function s.actfilter(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.actfilter,tp,LOCATION_HAND+ LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) end
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.actfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		--
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetLabel(tc:GetCode())
		e1:SetValue(s.aclimit)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.aclimit(e,re,tp)
	return not re:GetHandler():IsCode(e:GetLabel()) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsType(TYPE_FIELD)
end
function s.costfilter(c)
	return c:IsType(TYPE_FIELD) and c:IsFaceup() and c:IsAbleToHandAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		if ft<0 then return false end
		if ft==0 then
			return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_MZONE,0,1,nil)
		else
			return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_ONFIELD,0,1,nil)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	if ft==0 then
		local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_COST)
	else
		local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_COST)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.spfilter(c,tp)
	return c:IsControler(1-tp)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.spfilter,1,nil,tp)
end
function s.oegop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() then
		local code=c:GetOriginalCode()
		--
		local cregister=Card.RegisterEffect
		Card.RegisterEffect=function(card,effect,flag)
			if effect and effect:IsHasType(EFFECT_TYPE_IGNITION) then
				--spell speed 2
				if effect:IsHasType(EFFECT_TYPE_IGNITION) then
					effect:SetType(EFFECT_TYPE_QUICK_O)
					effect:SetCode(EVENT_FREE_CHAIN)
					effect:SetHintTiming(TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER,TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
				end
			end
			local id=cregister(card,effect,flag)
			Star_universe_monster_effect_table[effect:GetFieldID()]=1999
			return id
		end
		local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD)
		Card.RegisterEffect=cregister
	end
end

-------------------------------Field_Effect-----------------------------------

function s.field_gettableeffect(c,ccode)
	if not Star_universe_field_effect_table[ccode] then
		local table_effect={}
		--
		local cregister=Card.RegisterEffect
		Card.RegisterEffect=function(card,effect,flag)
			if effect and (effect:IsHasType(EFFECT_TYPE_IGNITION) or effect:IsHasType(EFFECT_TYPE_ACTIVATE)) then
				local eff=effect:Clone()
				table.insert(table_effect,eff)
			end
			return
		end
		--Duel.DisableActionCheck(true)
		Duel.CreateToken(0,ccode)
		--Duel.DisableActionCheck(false)
		--activate
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,4))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_ACTIVATE)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetTarget(s.xyztg)
		e1:SetOperation(s.xyzop)
		table.insert(table_effect,e1)
		--
		Card.RegisterEffect=cregister
		Star_universe_field_effect_table[ccode]=table_effect
	end
	return Star_universe_field_effect_table[ccode]
end
function s.xyzfilter(c)
	return c:IsXyzSummonable(nil)
end
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
	end
end
function s.rthatg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ccode=c:GetOriginalCode()
	local fetable=s.field_gettableeffect(c,ccode)
	if chk==0 then 
		if not fetable or #fetable<=0 then return false end
		for k,v in ipairs(fetable) do
			if v then
				local tg=v:GetTarget()
				if not tg or (tg and tg(e,tp,eg,ep,ev,re,r,rp,0)) then return true end
			end
		end
		return false
	end
	local optable={}
	local off=1
	local ops={}
	for k,v in ipairs(fetable) do
		if v then
			local tg=v:GetTarget()
			if not tg or (tg and tg(e,tp,eg,ep,ev,re,r,rp,0)) then 
				table.insert(optable,v)
				ops[off]=v:GetDescription()
				off=off+1
			end
		end
	end
	if #optable<=0 then return false end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local seleff=optable[op+1]:Clone()
	Duel.ClearTargetCard()
	e:SetLabelObject(seleff)
	local tg=seleff:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function s.rthaop(e,tp,eg,ep,ev,re,r,rp)
	local eff=e:GetLabelObject()
	if eff then
		local op=eff:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
