--虚拟水神的乱流
if not pcall(function() require("expansions/script/c65020201") end) then require("script/c65020201") end
local m,cm=rscf.DefineCard(65020204,"VrAqua")
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1},"rm",nil,rscon.excard2(rsva.filter_a,LOCATION_MZONE),nil,cm.tg,cm.act)
end
function cm.rmfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end
function cm.rmfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TRAP) and c:IsAbleToRemove()
end
function cm.rmfilter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.rmfilter1,tp,0,rsloc.og,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.rmfilter2,tp,0,rsloc.og,1,nil)
	local b3=Duel.IsExistingMatchingCard(cm.rmfilter3,tp,0,rsloc.og,1,nil)
	if chk==0 then return b1 or b2 or b3 end
	local op=rsop.SelectOption(tp,b1,{m,0},b2,{m,1},b3,{m,2})
	e:SetLabel(op)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_NORMAL) and rsva.filter_rl(c)
end
function cm.act(e,tp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==1 then
		if rsop.SelectRemove(tp,aux.NecroValleyFilter(cm.rmfilter1),tp,0,rsloc.og,1,1,nil,{})>0 and Duel.GetOperatedGroup():GetFirst():IsLocation(LOCATION_REMOVED) and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) then
			local e1=rsef.FV_LIMIT({c,tp},"dis",nil,aux.FilterBoolFunction(Card.IsType,TYPE_SPELL),{ 0,LOCATION_ONFIELD },nil,rsreset.pend)
		end
	elseif op==2 then
		if rsop.SelectRemove(tp,aux.NecroValleyFilter(cm.rmfilter2),tp,0,rsloc.og,1,1,nil,{})>0 and Duel.GetOperatedGroup():GetFirst():IsLocation(LOCATION_REMOVED) and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) then
			local e1=rsef.FV_LIMIT({c,tp},"dis",nil,aux.FilterBoolFunction(Card.IsType,TYPE_SPELL),{ 0,LOCATION_ONFIELD },nil,rsreset.pend)
		end
	else
		local ct,og,tc=rsop.SelectRemove(tp,aux.NecroValleyFilter(cm.rmfilter3),tp,0,rsloc.og,1,1,nil,{})
		if tc and tc:IsType(TYPE_MONSTER) and tc:IsLocation(LOCATION_REMOVED) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e1:SetTarget(cm.distg)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetCondition(cm.discon)
			e2:SetOperation(cm.disop)
			e2:SetLabelObject(tc)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function cm.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end