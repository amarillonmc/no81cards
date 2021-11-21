--Orth Saints Gray 2nd
if not pcall(function() require("expansions/script/c16104200") end) then require("script/c16104200") end
local m,cm=rk.set(16104202)
function cm.initial_effect(c)
	local e0,e0_1=rkch.PenTri(c,m,cm.cost)
	local e1=rkch.GainEffect(c,m)
	local e2=rsef.QO(c,EVENT_FREE_CHAIN,{m,2},{1},"eq",nil,LOCATION_MZONE,rkch.gaincon(m),cm.eqcost,rsop.target(cm.eqfilter,"eq",LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE),cm.eqop)
	local e2_1=rsef.SV_INDESTRUCTABLE(c,"effect",1,cm.gaincon)
	local e3=rkch.MonzToPen(c,m,EVENT_RELEASE,nil)
	local e4=rkch.PenAdd(c,{m,1},{1},{},false)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCondition(cm.condition)
	e5:SetOperation(cm.operation)
	c:RegisterEffect(e5)
end
cm.dff=true
function cm.gaincon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetEquipCount()>0 and c:GetFlagEffect(m)>0
end
function cm.costfilter2(c,tp,rc)
	local minc,maxc=rc:GetTributeRequirement()
	local g=Duel.GetTributeGroup(rc)
	return c:IsType(TYPE_SPELL) and (c:IsFaceup() or c:IsControler(tp)) and c:IsReleasable() and g:CheckSubGroup(cm.checkfun,1,maxc,rc,c,minc,maxc)
end 
function cm.checkfun(g,rc,c,minc,maxc)
	return Duel.CheckTribute(rc,minc,maxc,g) and not g:IsContains(c) and not g:IsContains(rc)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.costfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,tp,c)
	if chk==0 then return g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:Select(tp,1,1,nil)
	Duel.Release(sg,REASON_COST)
end
function cm.costfilter(c,ec)
	return c:IsReleasable() and Duel.IsExistingMatchingCard(cm.eqfilter,0,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,c,ec)
end 
function cm.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,c,c)
	if chk==0 then return g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:Select(tp,1,1,nil)
	Duel.Release(sg,REASON_COST)
end
function cm.eqfilter(c,ec)
	if aux.GetValueType(ec)=="effect" then
		ec=ec:GetHandler()
	end
	return (c:IsLocation(LOCATION_ONFIELD) and c:GetEquipTarget()~=ec) or (c:IsLocation(LOCATION_GRAVE) and not c:IsForbidden()) and c~=ec 
end
function cm.eqop(e,tp)
	local c=aux.ExceptThisCard(e)
	if c and c:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.eqfilter),tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,c,c)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.HintSelection(g)
			if not Duel.Equip(tp,tc,c,true) then return end
							--equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(c)
			e1:SetValue(cm.eqlimit)
			tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				e2:SetValue(2000)
				tc:RegisterEffect(e2)
				local e3=e2:Clone()
				e3:SetCode(EFFECT_UPDATE_DEFENSE)
				tc:RegisterEffect(e3)
		end
	end
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function cm.disfilter(c,seq)
	return c:GetSequence()==seq
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	local g=Group.FromCards(c)
	local rg=c:GetEquipGroup()
	if rg then
		g:Merge(rg)
	end
	if re:GetHandler():IsControler(tp) then
		return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and (c:GetSequence()==seq or (c:GetEquipGroup() and c:GetEquipGroup():IsExists(cm.disfilter,1,nil,seq))) and not rg:IsContains(re:GetHandler()) and c:IsSummonType(SUMMON_TYPE_ADVANCE) and loc&LOCATION_SZONE~=0
	else
		return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and (c:GetSequence()==4-seq or (c:GetEquipGroup() and c:GetEquipGroup():IsExists(cm.disfilter,1,nil,4-seq))) and not rg:IsContains(re:GetHandler()) and c:IsSummonType(SUMMON_TYPE_ADVANCE) and loc&LOCATION_SZONE~=0
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end