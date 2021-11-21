--教团的圣女 让·达克
if not pcall(function() require("expansions/script/c16104200") end) then require("script/c16104200") end
local m,cm=rk.set(16104232)
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e0=rkch.MonzToPen(c,m,EVENT_LEAVE_FIELD,true)
	local e1=rsef.STO(c,EVENT_SUMMON_SUCCESS,{m,0},{1,m},"disd","de,dsp",nil,nil,rsop.target(cm.setfilter,nil,LOCATION_DECK,0,3),cm.setop)
	local e2=rsef.RegisterClone(c,e1,"code",EVENT_SPSUMMON_SUCCESS)
	local e3=rsef.I(c,{m,1},{1,m+1},"th","de,dsp",LOCATION_PZONE,nil,cm.thcost,rsop.target(cm.thfilter,"th",LOCATION_GRAVE),cm.thop)
	local e4=rsef.SC(c,EVENT_RELEASE,nil,nil)
	e4:RegisterSolve(cm.secon,nil,nil,cm.seop)
end
function cm.setfilter(c)
	return c:IsSetCard(0x5ccd,0x6ccd) and c:IsSSetable()
end
function cm.setop(e,tp)
	if Duel.IsPlayerCanSummon(tp) and Duel.IsPlayerCanAdditionalSummon(tp) and Duel.GetFlagEffect(tp,m)==0 then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetValue(0x1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
	local g=Duel.GetMatchingGroup(cm.setfilter,tp,LOCATION_DECK,0,nil)
	if #g<3 then return end
	rshint.Select(tp,HINTMSG_SELF)
	local sg=g:Select(tp,3,3,nil)
	Duel.ConfirmCards(1-tp,sg)
	rshint.Select(1-tp,HINTMSG_SET)
	local tg=sg:Select(1-tp,1,1,nil)
	--Duel.HintSelection(tg)
	Duel.SSet(tp,tg:GetFirst())
	sg:Sub(tg)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function cm.thfilter(c)
	if not c:IsSetCard(0xccd) then return false end
	local b1 = c:IsAbleToHand()
	local b2 = c:IsType(TYPE_CONTINUOUS+TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true)
	return b1 or b2
end
function cm.thop(e,tp)
	local c=aux.ExceptThisCard(e)
	if c then
		rsop.SelectSolve(HINTMSG_SELF,tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,1,nil,cm.solvefun,tp)
	end
end
function cm.solvefun(g,tp)
	local tc=g:GetFirst()
	local b1 = tc:IsAbleToHand()
	local b2 = tc:IsType(TYPE_CONTINUOUS+TYPE_FIELD) and tc:GetActivateEffect():IsActivatable(tp,true)
	local op = rsop.SelectOption(tp,b1,{m,1},b2,{m,2})
	if op == 1 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	else
		local loc=LOCATION_SZONE
		if tc:IsType(TYPE_FIELD) then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			loc=LOCATION_FZONE
		end
		Duel.MoveToField(tc,tp,tp,loc,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	end
	return true
end
function cm.secon(e,tp)
	local c=e:GetHandler()
	return c:IsComplexReason(REASON_SUMMON+REASON_MATERIAL)
end
function cm.seop(e,tp)
	local c=e:GetHandler()
	local tc=c:GetReasonCard()
	if tc.dff==true then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_SUMMON_SUCCESS)
		e2:SetProperty(EFFECT_FLAG_OATH)
		e2:SetOperation(cm.regop1)
		e2:SetReset(RESET_EVENT+0x7e0000)
		tc:RegisterEffect(e2)
	end
end
function cm.adfilter(c)
	return c:GetOriginalCode()==m
end
function cm.regop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if tc:IsSummonPlayer(tp) and tc:IsSummonType(SUMMON_TYPE_ADVANCE) then
		tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(16104200,3))
	end
end