--残星倩影 不知归途
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=33700990
local cm=_G["c"..m]
if not rsv.Starspirit then
	rsv.Starspirit={}
	rsss=rsv.Starspirit
function rsss.TargetFunction(c,reset)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_TOGRAVE)
	e1:SetCondition(rsss.sdcon)
	if reset then
		e1:SetReset(rsreset.est)
	end
	c:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetOperation(rsss.desop1)
	if reset then
		e2:SetReset(rsreset.est)
	end
	c:RegisterEffect(e2,true)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetOperation(rsss.desop2)
	e3:SetLabelObject(e2)
	if reset then
		e3:SetReset(rsreset.est)
	end
	c:RegisterEffect(e3,true)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_BATTLED)
	e4:SetOperation(rsss.desop3)
	e4:SetLabelObject(e2)
	if reset then
		e4:SetReset(rsreset.est)
	end
	c:RegisterEffect(e4,true)
end
function rsss.sdcon(e)
	return e:GetHandler():GetOwnerTargetCount()>0 and not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),33701004)
end
function rsss.desop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_MZONE) and c:IsFaceup() then
		e:SetLabelObject(re)
		e:SetLabel(0)
	end
end
function rsss.desop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re==e:GetLabelObject():GetLabelObject() and c:IsRelateToEffect(re) and not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),33701004) then
		if Duel.GetCurrentPhase()==PHASE_DAMAGE and not Duel.IsDamageCalculated() then
			e:GetLabelObject():SetLabel(1)
		else
			if c:IsHasEffect(EFFECT_DISABLE) then return end
			if not c:IsDisabled() then Duel.SendtoGrave(c,REASON_EFFECT) end
		end
	end
end
function rsss.desop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local des=e:GetLabelObject():GetLabel()
	e:GetLabelObject():SetLabel(0)
	if c:IsHasEffect(EFFECT_DISABLE) then return end
	if des==1 and not c:IsDisabled() and not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),33701004) then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end
function rsss.SpecialSummonRule(c,con)
	local e1=rscf.SetSpecialSummonProduce(c,LOCATION_HAND+LOCATION_GRAVE,rsss.sscon(con),rsss.ssop)
	e1:SetValue(1)
	return e1
end
function rsss.sscon(con)
	return function(e,c)
		if c==nil then return true end
		local tp=c:GetControler()
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and con(e,tp)
	end
end
function rsss.ssop(e,tp,eg,ep,ev,re,r,rp,c)
	if c:IsLocation(LOCATION_GRAVE) then
		local e1=rsef.SV_REDIRECT(c,"leave",LOCATION_REMOVED,nil,rsreset.est-RESET_TOFIELD)
	end
end
function rsss.MatFunction(c,fun)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCondition(rsss.efcon)
	e1:SetOperation(rsss.efop(fun))
	c:RegisterEffect(e1)
end
function rsss.efcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	return rc:IsPreviousLocation(LOCATION_EXTRA)
end
function rsss.efop(fun)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local rc=c:GetReasonCard()
		rsss.TargetFunction(rc,true)
		local e1=fun(rc)
		e1:SetReset(rsreset.est)
		if not rc:IsType(TYPE_EFFECT) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_ADD_TYPE)
			e2:SetValue(TYPE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e2,true)
		end
	end
end
function rsss.DirectAttackFun(c,con)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(con)
	c:RegisterEffect(e1)
end
function rsss.DamageFunction(c,op)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(rsss.damfuncon)
	e1:SetOperation(op)
	c:RegisterEffect(e1)
end
function rsss.damfuncon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function rsss.NoTributeFunction(c,con,fun)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,5))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(rsss.ntcon(con))
	e1:SetOperation(rsss.ntop(fun))
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
end
function rsss.ntcon(con)
	return function(e,c,minc)
		if c==nil then return true end
		return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and con(e,e:GetHandlerPlayer())
	end
end
function rsss.ntop(fun)
	return function(e,tp,eg,ep,ev,re,r,rp,c)
		local e1=fun(c)
		e1:SetReset(rsreset.est-RESET_TOFIELD)
	end
end
function rsss.ActFieldFunction(c,code)
	local e1=rsef.QO(c,nil,{m,6},{1,code},nil,nil,LOCATION_FZONE,nil,rscost.costself(Card.IsAbleToDeckAsCost,"td"),rsss.actg,rsss.acop)  
	e1:SetLabel(code)
	return e1
end
function rsss.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(rsss.acfilter,tp,LOCATION_DECK,0,1,nil,tp,e:GetLabel()) end
end
function rsss.acfilter(c,tp,code)
	if not c:IsType(TYPE_FIELD) then return false end
	local te=c:GetActivateEffect()
	return te:IsActivatable(tp,true) and c:IsSetCard(0x144d) and not c:IsCode(code)
end
function rsss.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,rsss.acfilter,tp,LOCATION_DECK,0,1,1,nil,tp,e:GetLabel()):GetFirst()
	if tc then
	   local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	   if fc then
		  Duel.SendtoGrave(fc,REASON_RULE)
		  Duel.BreakEffect()
	   end
	   Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	   local te=tc:GetActivateEffect()
	   local tep=tc:GetControler()
	   local cost=te:GetCost()
	   if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	   Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function rsss.CounterFunction(c)
	c:EnableCounterPermit(0x1a)
	local e1=rsef.FTO(c,EVENT_TO_GRAVE,{m,7},nil,"ct,dam","de",LOCATION_SZONE,rsss.ctcon,nil,rsss.cttg,rsss.ctop)
end
function rsss.ctcon(e,tp,eg)
	local f=function(c)
		return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_EFFECT) and c:GetReasonEffect():GetHandler()==c
	end
	return eg:IsExists(f,1,nil)
end
function rsss.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function rsss.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=rscf.GetRelationThisCard()
	if not c then return end
	Duel.Damage(tp,500,REASON_EFFECT)
	c:AddCounter(0x1a,1)
end
---------------
end
---------------
if cm then
function cm.initial_effect(c)
	rsss.TargetFunction(c)
	rsss.SpecialSummonRule(c,cm.con)
	rsss.MatFunction(c,cm.fun)
end
function cm.con(e,tp)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil)
end
function cm.fun(rc)
	local e1=rsef.I({rc,true},{m,0},1,"se,th",nil,LOCATION_MZONE,nil,nil,cm.tg,cm.op)
	return e1
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x144d)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
---------------
end