--绮罗星列流星辉巧群
local m=11612619
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost) 
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost) 
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.activate2)
	c:RegisterEffect(e2)
	if not cm.global_flag then
		cm.global_flag=true
		Sr_srlesetback={}
		Sr_srlesetback[1]=0 
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.regop)
		Duel.RegisterEffect(ge1,0)
	end
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.regfilter(c,tp)
	return c:GetSummonType(SUMMON_TYPE_RITUAL)-- and c:IsSetCard(0x154)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	if not eg then return end
	local sg=eg:Filter(cm.regfilter,nil,tp)
	local tc=sg:GetFirst()
	while tc do
		Sr_srlesetback[#Sr_srlesetback+1]=tc:GetCode()
		tc=sg:GetNext()
	end
end
function cm.counterfilter(c)
	return not c:IsSummonableCard() 
end
--
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp) 
end
function cm.splimit(e,c)
	return c:IsSummonableCard()
end
function cm.spfil(c,e,tp) 
	return c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and c:IsCode(table.unpack(Sr_srlesetback))   
end 
function cm.rmfil(c) 
	return c:IsSetCard(0x154) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()  
end 
function cm.rgck(g,e,tp) 
	local sg=Duel.GetMatchingGroup(cm.spfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	return sg:CheckSubGroup(cm.spgck,1,5,e,tp,g)  
end 
function cm.spgck(g,e,tp,rg) 
	if Duel.IsPlayerAffectedByEffect(tp,59822133) and g:GetCount()>1 then return false end 
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>=g:GetCount() and rg:CheckWithSumGreater(Card.GetAttack,g:GetSum(Card.GetAttack)) 
end 
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(cm.rmfil,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then return g:CheckSubGroup(cm.rgck,1,99,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end 
function cm.activate(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(cm.rmfil,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local xg=Duel.GetMatchingGroup(cm.spfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	if g:CheckSubGroup(cm.rgck,1,99,e,tp) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local rg=g:SelectSubGroup(tp,cm.rgck,false,1,99,e,tp) 
		--Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_RITUAL+REASON_MATERIAL)
		Duel.SendtoDeck(rg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=xg:SelectSubGroup(tp,cm.spgck,false,1,5,e,tp,rg) 
		--local sg=xg:CheckSubGroup(cm.spgck,1,5,e,tp,rg)
		--local sg=xg:Filter(cm.spgck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp,rg)
		local sg1=sg:SelectSubGroup(tp,aux.drccheck,false,1,5)
		local sc=sg1:GetFirst() 
		while sc do 
			sc:SetMaterial(rg)
			Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)   
			sc:CompleteProcedure()
		sc=sg1:GetNext() 
		end 
	end 
end 
--
function cm.spfil2(c,e,tp) 
	return c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end 
function cm.rmfil2(c) 
	return c:IsSetCard(0x154) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()  
end 
function cm.rgck2(g,e,tp) 
	local sg=Duel.GetMatchingGroup(cm.spfil2,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND,0,nil,e,tp)
	return sg:CheckSubGroup(cm.spgck2,1,5,e,tp,g)  
end 
function cm.spgck2(g,e,tp,rg) 
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>=1 and rg:CheckWithSumGreater(Card.GetAttack,g:GetSum(Card.GetAttack)) 
end 
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(cm.rmfil2,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:CheckSubGroup(cm.rgck2,1,99,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND)
end 
function cm.activate2(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(cm.rmfil2,tp,LOCATION_DECK,0,nil)
	local xg=Duel.GetMatchingGroup(cm.spfil2,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND,0,nil,e,tp)
	if g:CheckSubGroup(cm.rgck2,1,99,e,tp) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=g:SelectSubGroup(tp,cm.rgck2,false,1,1,e,tp) 
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_RITUAL+REASON_MATERIAL)
		--Duel.SendtoDeck(rg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=xg:SelectSubGroup(tp,cm.spgck2,false,1,1,e,tp,rg) 
		--local sg=xg:CheckSubGroup(cm.spgck,1,5,e,tp,rg)
		--local sg=xg:Filter(cm.spgck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp,rg)
		--local sg1=sg:SelectSubGroup(tp,aux.drccheck,false,1,1)
		local sc=sg:GetFirst()
		Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)   
		sc:CompleteProcedure()
	end 
end 