local m=87536666
local cm=_G["c"..m]
cm.name="米斯特汀之虫惑魔"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Ritual mats
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(cm.con)
	e0:SetOperation(cm.tnop)
	c:RegisterEffect(e0)
	--r summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetHintTiming(0,TIMING_CHAIN_END+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(cm.rcon)
	e1:SetTarget(cm.rtg)
	e1:SetOperation(cm.rop)
	c:RegisterEffect(e1)
	--copy trap
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMING_CHAIN_END+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.con)
	e3:SetOperation(cm.chainop)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.con)
	e4:SetValue(cm.efilter)
	c:RegisterEffect(e4)
	--
	if not cm.global_check then
		cm.global_check=true
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_TO_GRAVE)
		e0:SetOperation(cm.regop)
		Duel.RegisterEffect(e0,0)
	end
end
function cm.tnop(e)
	local c=e:GetHandler()
	c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
end
function cm.tyfilter(c)
	return c:GetType()==TYPE_TRAP
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		if eg:IsExists(cm.tyfilter,1,nil) then
			Duel.RegisterFlagEffect(p,m,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0
end
function cm.rfilter(c,sc,e,tp)
	local b1=c:IsLocation(LOCATION_HAND)
	local b2=c:IsSetCard(0x4c,0x89) and c:IsLocation(LOCATION_DECK)
	local res=1
	local seg=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)
	if seg then
		for _,i in ipairs{seg} do
			local tg=i:GetTarget()
			if not tg then res=0 end
			if tg and tg(e,c,tp,REASON_EFFECT) then res=0 end
		end
	end 
	if c:IsHasEffect(EFFECT_UNRELEASABLE_NONSUM) then res=0 end
	if c:IsHasEffect(EFFECT_UNRELEASABLE_EFFECT) then res=0 end
	return c:IsAbleToGrave() and c:GetType()==TYPE_TRAP and (b1 or b2) and res==1
end
function cm.rlevel(c)
	if c:GetType()==TYPE_TRAP then return 4 end
	return 0
end
function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	--local seg=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)
	--local res=1
	--if seg then
	--  for _,i in ipairs{seg} do
	--	  local tg=i:GetTarget()
	--	  if not tg then res=0 end
	--	  if tg and tg(e,c,tp,REASON_EFFECT) then res=0 end
	--  end
	--end
	local g=Duel.GetMatchingGroup(cm.rfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,c,e,tp)
	if chk==0 then return g:CheckWithSumGreater(cm.rlevel,c:GetLevel()) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.rfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,c,e,tp)
	--local seg=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)
	--local res=1
	--if seg then
	--  for _,i in ipairs{seg} do
	--	  local tg=i:GetTarget()
	--	  if not tg then res=0 end
	--	  if tg and tg(e,c,tp,REASON_EFFECT) then res=0 end
	--  end
	--end
	--if res==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local mat=g:SelectWithSumGreater(tp,cm.rlevel,c:GetLevel())
	if #mat>0 then
		c:SetMaterial(mat)
		if Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RELEASE)>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			c:CompleteProcedure()
		end
	end
end
function cm.filter(c)
	return c:GetType()==TYPE_TRAP and not c:IsCode(79766336,22628574) and c:CheckActivateEffect(false,true,false)~=nil
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil) end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local tg=te:GetTarget()
	e:SetProperty(te:GetProperty())
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	local tc=te:GetHandler()
	if not (tc:IsRelateToEffect(e) and tc:GetType()==TYPE_TRAP) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActivated() and ep~=tp then
		Duel.SetChainLimit(cm.chainlm1)
	end
	if re:IsActiveType(TYPE_MONSTER) then
		Duel.SetChainLimit(cm.limit2(re:GetHandler()))
	end
end
function cm.limit2(c)
	return  function (e,rp,tp)
				return tp==rp or not (e:GetHandler():IsType(TYPE_MONSTER) and e:GetHandler():GetAttack()>=c:GetAttack())
			end
end
function cm.chainlm1(e,rp,tp)
	return tp==rp
end
function cm.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end