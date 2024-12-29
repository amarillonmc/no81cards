--荣耀与胜利之龙
--lua by bibeak_will
function c43000000.initial_effect(c)
	aux.AddCodeList(c,51925001)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--summon with ? tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43000000,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c43000000.ttcon)
	e1:SetOperation(c43000000.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e2)
	--rin power
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c43000000.valcheck)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SUMMON_COST)
	e4:SetOperation(c43000000.facechk)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
function c43000000.ttcon(e,c,minc)
	if c==nil then return true end
	return Duel.CheckTribute(c,1)
end
function c43000000.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,1,99)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c43000000.valcheck(e,c)
	local g=c:GetMaterial()
	if e:GetLabel()==1 then
		e:SetLabel(0)
		if g:IsExists(Card.IsSetCard,1,nil,0x3256) then
			--immune
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(c43000000.efilter)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			c:RegisterEffect(e1)
			local e11=Effect.CreateEffect(c)
			e11:SetDescription(aux.Stringid(43000000,1))
			e11:SetType(EFFECT_TYPE_SINGLE)
			e11:SetCode(43000000)
			e11:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e11:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			c:RegisterEffect(e11)
		end
		if g:IsExists(Card.IsSetCard,1,nil,0x3257) then
			--direct attack
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DIRECT_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			c:RegisterEffect(e2)
			--atk
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UPDATE_ATTACK)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetValue(c43000000.atkval)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			c:RegisterEffect(e3)
		end
		if g:IsExists(Card.IsSetCard,1,nil,0x6256) then
			--Normal monster
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_ADD_TYPE)
			e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e4:SetRange(LOCATION_MZONE)
			e4:SetValue(TYPE_NORMAL)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			c:RegisterEffect(e4)
		end
		if g:IsExists(c43000000.claralist,1,nil) then
			--change cdoe
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_IGNITION)
			e5:SetRange(LOCATION_MZONE)
			e5:SetCountLimit(1)
			e5:SetCost(c43000000.cccost)
			e5:SetOperation(c43000000.ccop)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			c:RegisterEffect(e5)
		end
		if g:IsExists(Card.IsSetCard,1,nil,0x9256) then
			--spsummon
			local e6=Effect.CreateEffect(c)
			e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e6:SetType(EFFECT_TYPE_QUICK_O)
			e6:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
			e6:SetRange(LOCATION_MZONE)
			e6:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
			e6:SetCondition(c43000000.spcon)
			e6:SetTarget(c43000000.sptg)
			e6:SetOperation(c43000000.spop)
			e6:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			c:RegisterEffect(e6)
		end
		if g:IsExists(Card.IsSetCard,1,nil,0x3258) then
			local e7=Effect.CreateEffect(c)
			e7:SetType(EFFECT_TYPE_QUICK_O)
			e7:SetCode(EVENT_CHAINING)
			e7:SetRange(LOCATION_MZONE)
			e7:SetCountLimit(1)
			e7:SetCondition(c43000000.setcon)
			e7:SetTarget(c43000000.settg)
			e7:SetOperation(c43000000.setop)
			e7:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			c:RegisterEffect(e7)
		end
		if g:IsExists(Card.IsSetCard,1,nil,0x5258) then
			local e8=Effect.CreateEffect(c)
			e8:SetType(EFFECT_TYPE_FIELD)
			e8:SetCode(EFFECT_CANNOT_RELEASE)
			e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e8:SetRange(LOCATION_MZONE)
			e8:SetTargetRange(0,1)
			e8:SetTarget(c43000000.rellimit)
			e8:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			c:RegisterEffect(e8)
		end
		if g:IsExists(Card.IsSetCard,1,nil,0x6258) then
			--twice bp
			local e9=Effect.CreateEffect(c)
			e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e9:SetCode(EVENT_ADJUST)
			e9:SetRange(LOCATION_MZONE)
			e9:SetOperation(c43000000.wbop)
			e9:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			c:RegisterEffect(e9)
			local e10=Effect.CreateEffect(c)
			e10:SetType(EFFECT_TYPE_FIELD)
			e10:SetCode(43000000)
			e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e10:SetRange(LOCATION_MZONE)
			e10:SetTargetRange(1,0)
			e10:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			c:RegisterEffect(e10)
		end
	end
end
function c43000000.facechk(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(1)
end
function c43000000.efilter(e,te)
	if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then
		return true
	elseif te:IsActiveType(TYPE_MONSTER) and te:IsActivated() then
		local lv=e:GetHandler():GetLevel()
		local ec=te:GetHandler()
		if ec:IsType(TYPE_LINK) then
			return ec:GetLink()<lv
		elseif ec:IsType(TYPE_XYZ) then
			return ec:GetOriginalRank()<lv
		else
			return ec:GetOriginalLevel()<lv
		end
	else
		return false
	end
end
function c43000000.atkval(e,c)
	return Duel.GetFieldGroupCount(0,LOCATION_REMOVED,LOCATION_REMOVED)*100
end
function c43000000.claralist(c)
	return aux.IsCodeListed(c,51925001)
end
function c43000000.tgfilter(c)
	return aux.IsCodeListed(c,51925001) and c:IsAbleToGraveAsCost()
end
function c43000000.cccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43000000.tgfilter,tp,LOCATION_EXTRA,0,1,nil)
		and not e:GetHandler():IsCode(51925001) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c43000000.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c43000000.ccop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(51925001)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		c:RegisterEffect(e1)
	end
end
function c43000000.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==Duel.GetAttacker() or c==Duel.GetAttackTarget()
end
function c43000000.spfilter(c,e,tp)
	return c:IsRace(RACE_THUNDER) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_TUNER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c43000000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c43000000.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c43000000.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c43000000.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c43000000.setcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c43000000.setfilter(c)
	return c:GetSequence()<5
end
function c43000000.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c43000000.setfilter,tp,0,LOCATION_MZONE,1,c) end
end
function c43000000.seqfilter(c,seq)
	return c:GetSequence()==seq
end
function c43000000.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c43000000.setfilter,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		if not tc:IsImmuneToEffect(e) then
			local p=1-tp
			local zone=1<<tc:GetSequence()
			local oc=Duel.GetMatchingGroup(c43000000.seqfilter,p,LOCATION_SZONE,0,nil,tc:GetSequence()):GetFirst()
			if oc then
				Duel.Destroy(oc,REASON_RULE)
			end
			if Duel.MoveToField(tc,p,p,LOCATION_SZONE,POS_FACEUP,true,zone) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
				tc:RegisterEffect(e1)
			end
		end
	end
end
function c43000000.rellimit(e,c,tp,sumtp)
	return c==e:GetHandler()
end
function c43000000.wbop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_BP_TWICE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c43000000.bpcon)
	--e1:SetReset(RESET_PHASE+PHASE_BATTLE)
	Duel.RegisterEffect(e1,tp)
end
function c43000000.bpcon(e)
	return Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),43000000)
end
