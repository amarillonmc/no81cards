--亚奥斯克的神孽
if not pcall(function() require("expansions/script/c30000100") end) then require("script/c30000100") end
local m,cm=rscf.DefineCard(30000430)
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),10,3,nil,nil,99)
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.limit)
	c:RegisterEffect(e1)
	local e2=rsef.SV_CANNOT_DISABLE_S(c)
	local e4=rsef.SV_IMMUNE_EFFECT(c)
	local e5,e6=rsef.SV_SET(c,"batk,bdef",cm.val)
	local e7=rsef.SV_LIMIT(c,"datk")
	local e8=rsef.FV_REDIRECT(c,"tg",LOCATION_REMOVED,nil,{0xff,0xff},cm.rmcon)
	local e9=rsef.I(c,"sp",1,"sp",nil,LOCATION_MZONE,cm.spcon,rscost.rmxyz(1),cm.sptg,cm.spop)
	local e10=rsef.FTF(c,EVENT_PHASE+PHASE_END,"rm",1,"rm",nil,LOCATION_MZONE,nil,nil,nil,cm.rmop)
	local e11=rsef.STF(c,EVENT_LEAVE_FIELD,"td",nil,"td,dam",nil,cm.tdcon,nil,rsop.target2(cm.tdfun,Card.IsAbleToDeck,"td",LOCATION_REMOVED,LOCATION_REMOVED,true,true,c),cm.tdop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_INACTIVATE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e12:SetCode(EFFECT_CANNOT_ACTIVATE)
	e12:SetRange(LOCATION_MZONE)
	e12:SetTargetRange(0,1)
	e12:SetValue(1)
	e12:SetCondition(cm.actcon)
	c:RegisterEffect(e12)
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetCode(EFFECT_ATTACK_COST)
	e13:SetCost(cm.atcost)
	e13:SetOperation(cm.atop)
	c:RegisterEffect(e13)
end
function cm.tdcon(e,tp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function cm.tdfun(g,e,tp)
	local dam = Duel.GetMatchingGroupCount(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,e:GetHandler())*500
end
function cm.tdop(e,tp)
	local g = Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,aux.ExceptThisCard(e))
	if #g>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		local dam = Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,rsloc.de) * 500
		Duel.SetLP(tp,Duel.GetLP(tp)-dam)
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)-dam)
	end
end
function cm.rmop(e,tp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,rsloc.hog,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	local b1 = c:IsAbleToRemove()
	local b2 = #g>0
	local op=rsop.SelectOption(tp,b1,{m,0},b2,{m,1})
	local rg = op==1 and c or g
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
end
function cm.limit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and not se
end
function cm.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:GetHandler()==e:GetHandler()
end
function cm.val(e,c)
	return Duel.GetFieldGroupCount(0,LOCATION_REMOVED,LOCATION_REMOVED)*1000
end
function cm.cfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsLevel(12) and c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.rmcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(cm.cfilter,1,nil)
end
function cm.cfilter2(c)
	return c:IsRace(RACE_DRAGON+RACE_WYRM) and c:IsLevel(10) and c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.spcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(cm.cfilter2,1,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,rsloc.hdg+LOCATION_EXTRA+LOCATION_GRAVE)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,1-tp,true,false,POS_FACEUP_ATTACK) and c:RemovePosCheck() and rszsf.GetUseAbleMZoneCount(c,1-tp)>0
end
function cm.spop(e,tp)
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,0,rsloc.hdg+LOCATION_EXTRA+LOCATION_GRAVE,nil,e,tp)
	if #sg<=0 then return end
	local sc
	local ct=0
	repeat 
		ct=ct+1
		if ct==2 and rscon.bsdcheck(1-tp) then break end
		sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,0,rsloc.hdg+LOCATION_EXTRA+LOCATION_GRAVE,nil,e,tp)
		if #sg>0 then
			rshint.Select(1-tp,"sp")
			sc = sg:Select(1-tp,1,1,nil):GetFirst()
			Duel.SpecialSummonStep(sc,0,1-tp,1-tp,true,false,POS_FACEUP_ATTACK)
		end
	until #sg == 0
	Duel.SpecialSummonComplete()
	local c=rscf.GetFaceUpSelf(e)
	if c then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ATTACK_ALL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function cm.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function cm.atcost(e,c,tp)
	return true
end
function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	local tc=g:GetFirst()
	local dis_n=0
	if not tc then return end
	while tc do
		if aux.disfilter1(tc) and not tc:IsImmuneToEffect(e) then dis_n=dis_n+1 end
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end
	if dis_n>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(dis_n*3000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end