--龙仪巧-水瓶流星=AQU
local m=11612611
local cm=_G["c"..m]
function c11612611.initial_effect(c)
	c:EnableReviveLimit()
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(cm.valcheck)
	c:RegisterEffect(e0)
	--cannot be effect target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
	--th
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(cm.matcon)
	e3:SetOperation(cm.matop)
	c:RegisterEffect(e3)
	e0:SetLabelObject(e3)
	--copy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,3))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m+1)
	e4:SetCost(cm.copycost)
	e4:SetCondition(cm.cpcon)
	e4:SetTarget(cm.cptg)
	e4:SetOperation(cm.cpop)
	c:RegisterEffect(e4)
end
function cm.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and e:GetLabel()==1
end
function cm.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
end
function cm.lvfilter(c,rc)
	return c:GetRitualLevel(rc)>0
end
function cm.valcheck(e,c)
	local mg=c:GetMaterial()
	local fg=mg:Filter(cm.lvfilter,nil,c)
	if #fg>0 and fg:GetSum(Card.GetRitualLevel,c)<=2 then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
--1
function cm.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
--2
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return e:GetHandler():GetFlagEffect(m)>0 and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function cm.etfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsReleasable()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.etfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.etfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.etfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local code=tc:GetCode()
	if tc:IsFaceup() then -- tc:IsRelateToEffect(e) and
		Duel.Release(tc,REASON_EFFECT)
		if aux.NecroValleyFilter()(tc) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
			if tc:IsSetCard(0x154) then
				tc:RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
			end
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(cm.aclimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_SUM)
	Duel.RegisterEffect(e2,tp)
end
function cm.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_MZONE and tp==e:GetHandlerPlayer() 
end
--03
function cm.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==1-tp
end
function cm.filter1(c)
	return c:CheckActivateEffect(true,true,false)
end
function cm.filter2(c,e,tp,eg,ep,ev,re,r,rp)
		if c:CheckActivateEffect(true,true,false) then return true end
		local te=c:GetActivateEffect()
		--if te:GetCode()~=EVENT_CHAINING then return false end
		local tg=te:GetTarget()
		if not tg then return true end
		local res=false
		if not pcall(function() res=tg(e,tp,eg,ep,ev,re,r,rp,0) end) then return false end
		return res
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0,chkc))
	end
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return cm.filter2(re:GetHandler(),e,tp,eg,ep,ev,re,r,rp)
	end
	e:SetLabel(0)
	local tc=re:GetHandler()
	local te,ceg,cep,cev,cre,cr,crp
	local fchain=cm.filter1(tc)
	if fchain then
		te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(true,true,true)
	else
		te=tc:GetActivateEffect()
	end
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then
		if fchain then
			tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
		else
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	e:GetHandler():ReleaseEffectRelation(e)
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end