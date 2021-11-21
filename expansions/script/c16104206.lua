--ORTH
if not pcall(function() require("expansions/script/c16104200") end) then require("script/c16104200") end
local m,cm=rscf.DefineCard(16104206,"CHURCH")
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsef.QO(c,nil,{m,1},1,"sum",nil,LOCATION_FZONE,nil,cm.cost,cm.target,cm.op)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SUMMON_PROC)
	e5:SetCondition(cm.advcon)
	e5:SetOperation(cm.advop)
	e5:SetValue(SUMMON_TYPE_ADVANCE)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(LOCATION_HAND+LOCATION_ONFIELD,0)
	e6:SetTarget(cm.advtg)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,0))
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_SET_PROC)
	e7:SetCondition(cm.advcon)
	e7:SetOperation(cm.advop)
	e7:SetValue(SUMMON_TYPE_ADVANCE)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e8:SetRange(LOCATION_FZONE)
	e8:SetTargetRange(LOCATION_HAND+LOCATION_ONFIELD,0)
	e8:SetTarget(cm.advtg)
	e8:SetLabelObject(e7)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e9:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e9:SetTarget(cm.rtg)
	e9:SetValue(POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
	e9:SetCondition(cm.excon)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e10:SetRange(LOCATION_FZONE)
	e10:SetTargetRange(LOCATION_HAND+LOCATION_ONFIELD,0)
	e10:SetTarget(cm.advtg)
	e10:SetLabelObject(e9)
	c:RegisterEffect(e10)
	--leav effect
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetCode(EVENT_LEAVE_FIELD)
	e11:SetCondition(cm.tdcon)
	e11:SetOperation(cm.tdop)
	c:RegisterEffect(e11)
end
function cm.excon(e)
	return not cm.check_s
end
function cm.advtg(e,c)
	return c:IsSetCard(0xccd)
end
function cm.otfilter(c)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.advcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cm.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	cm.check_s = true
	local res = c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
	cm.check_s = false
	return res
end
function cm.advop(e,tp,eg,ep,ev,re,r,rp,c)
	cm.check_s = true
	local mg=Duel.GetMatchingGroup(cm.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
	cm.check_s = false
end
function cm.rtg(e,c)
	return c:IsFaceup() and c~=e:GetHandler()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.sumfilter(c)
	return c:IsSetCard(0x3ccd) and c:IsSummonable(true,nil) and not c:IsPublic()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==1 then
			return Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND,0,1,nil)
		else
			return false
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g then
		local tc=g:GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		e:SetLabelObject(tc)
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,tc,1,tp,LOCATION_HAND)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=e:GetLabelObject()
	if not tc or tc:GetFlagEffect(m)==0  or not tc:IsSummonable(true,nil) then return end
	Duel.Summon(tp,tc,true,nil)
	if tc:GetOriginalLevel()>4 and tc:IsOriginalSetCard(0x3ccd) and tc:GetFlagEffect(tc:GetOriginalCode())==0 then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_SUMMON_SUCCESS)
		e2:SetProperty(EFFECT_FLAG_OATH)
		e2:SetOperation(cm.regop1)
		e2:SetReset(RESET_EVENT+0x7e0000)
		tc:RegisterEffect(e2)
	end
end
function cm.regop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if tc:IsSummonPlayer(tp) and tc:IsSummonType(SUMMON_TYPE_ADVANCE) then
		tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(16104200,3))
	end
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_EFFECT) and c:IsPreviousPosition(POS_FACEUP)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabelObject(c)
	e1:SetOperation(cm.thop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if (tc:IsFaceup() or tc:IsLocation(LOCATION_GRAVE) or tc:IsPublic()) and tc:GetActivateEffect():IsActivatable(tp,true,true) then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		local te=tc:GetActivateEffect()
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
			