local m=53736010
local cm=_G["c"..m]
cm.name="暗从者-灭迹"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),aux.Tuner(nil),nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_DARK),1,1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.limcon)
	e1:SetOperation(cm.limop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetOperation(cm.limop2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.limcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(cm.chlimit)
	elseif Duel.GetCurrentChain()==1 then
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(cm.resetop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_BREAK_EFFECT)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.resetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(m)
	e:Reset()
end
function cm.limop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(m)~=0 then
		Duel.SetChainLimitTillChainEnd(cm.chlimit)
	end
	e:GetHandler():ResetFlagEffect(m)
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function cm.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		c:SetCardTarget(tc)
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e0:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e0:SetValue(LOCATION_DECKBOT)
		tc:RegisterEffect(e0)
		if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
		local b1=not (c:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) and c:IsHasEffect(EFFECT_INDESTRUCTABLE_EFFECT))
		local b2=not (c:IsHasEffect(EFFECT_CANNOT_BE_BATTLE_TARGET) and c:IsHasEffect(EFFECT_CANNOT_BE_EFFECT_TARGET))
		local off=1
		local ops={}
		local opval={}
		if b1 then
			ops[off]=aux.Stringid(m,1)
			opval[off]=0
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(m,2)
			opval[off]=1
			off=off+1
		end
		ops[off]=aux.Stringid(m,3)
		opval[off]=2
		off=off+1
		local op=Duel.SelectOption(tp,table.unpack(ops))+1
		local sel=opval[op]
		if sel==0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(tc)
			e1:SetCondition(cm.indcon)
			e1:SetValue(aux.imval1)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e2:SetValue(aux.tgoval)
			c:RegisterEffect(e2)
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4))
		elseif sel==1 then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			e3:SetLabelObject(tc)
			e3:SetCondition(cm.indcon)
			e3:SetValue(1)
			c:RegisterEffect(e3)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			c:RegisterEffect(e4)
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,5))
		else
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e5:SetCode(EFFECT_UPDATE_ATTACK)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD)
			e5:SetLabelObject(tc)
			e5:SetCondition(cm.indcon)
			e5:SetValue(700)
			c:RegisterEffect(e5)
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,6))
		end
	end
end
function cm.indcon(e)
	if not e:GetHandler():GetCardTarget():IsContains(e:GetLabelObject()) then
		e:Reset()
		return false
	else return true end
end
