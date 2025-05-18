--破茧之月神
function c9910056.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_FAIRY),1)
	c:EnableReviveLimit()
	--activate effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9910056)
	e1:SetTarget(c9910056.target)
	e1:SetOperation(c9910056.operation)
	c:RegisterEffect(e1)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_ONFIELD)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1)
end
function c9910056.actfilter(c,tp)
	return c:IsCode(9910059) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c9910056.xyzfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsXyzSummonable(nil)
end
function c9910056.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c9910056.actfilter,tp,LOCATION_DECK,0,1,nil,tp)
	local b2=Duel.IsExistingMatchingCard(c9910056.xyzfilter,tp,LOCATION_EXTRA,0,1,nil)
	if chk==0 then return b1 or b2 end
	e:SetCategory(0)
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(9910056,0)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(9910056,1)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==0 then
		e:SetCategory(0)
	elseif sel==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end
function c9910056.operation(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c9910056.actfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
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
		end
	elseif sel==1 then
		local g=Duel.GetMatchingGroup(c9910056.xyzfilter,tp,LOCATION_EXTRA,0,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=g:Select(tp,1,1,nil)
			Duel.XyzSummon(tp,tg:GetFirst(),nil)
		end
	end
end
