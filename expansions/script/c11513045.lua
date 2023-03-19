--最强之龙的星诞
function c11513045.initial_effect(c)
	aux.AddCodeList(c,11513043)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11513045) 
	e1:SetCost(c11513045.actg)
	e1:SetOperation(c11513045.acop)
	c:RegisterEffect(e1) 
	--to deck and draw 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED) 
	e2:SetCountLimit(1,21513045) 
	e2:SetCondition(aux.exccon)
	e2:SetCost(c11513045.tdrcost) 
	e2:SetTarget(c11513045.tdrtg) 
	e2:SetOperation(c11513045.tdrop) 
	c:RegisterEffect(e2)
end 
function c11513045.rlfil1(c,e) 
	if c:IsImmuneToEffect(e) then return false end  
	return c:IsReleasable()   
end 
function c11513045.rlfil2(c,e) 
	if c:IsImmuneToEffect(e) then return false end  
	return c:IsType(TYPE_RITUAL+TYPE_XYZ+TYPE_SYNCHRO+TYPE_LINK+TYPE_FUSION+TYPE_PENDULUM) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() 
end 
function c11513045.rlgck1(g,tp) 
	return Duel.GetMZoneCount(tp,g)>0  
end 
function c11513045.rlgck2(g,tp) 
	return g:FilterCount(Card.IsType,nil,TYPE_RITUAL)<=1 
	   and g:FilterCount(Card.IsType,nil,TYPE_XYZ)<=1 
	   and g:FilterCount(Card.IsType,nil,TYPE_SYNCHRO)<=1 
	   and g:FilterCount(Card.IsType,nil,TYPE_LINK)<=1 
	   and g:FilterCount(Card.IsType,nil,TYPE_FUSION)<=1 
	   and g:FilterCount(Card.IsType,nil,TYPE_PENDULUM)<=1  
end 
function c11513045.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and c:IsCode(11513043)   
end 
function c11513045.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g1=Duel.GetMatchingGroup(c11513045.rlfil1,tp,LOCATION_MZONE,0,nil,e)
	local g2=Duel.GetMatchingGroup(c11513045.rlfil2,tp,LOCATION_GRAVE,0,nil,e)
	if chk==0 then return Duel.IsExistingMatchingCard(c11513045.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) and (g1:CheckSubGroup(c11513045.rlgck1,1,99,tp) or g2:CheckSubGroup(c11513045.rlgck2,1,6,tp)) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c11513045.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local sg=Duel.GetMatchingGroup(c11513045.spfil,tp,LOCATION_HAND,0,nil,e,tp)
	local g1=Duel.GetMatchingGroup(c11513045.rlfil1,tp,LOCATION_MZONE,0,nil,e)
	local g2=Duel.GetMatchingGroup(c11513045.rlfil2,tp,LOCATION_GRAVE,0,nil,e) 
	local b1=g1:CheckSubGroup(c11513045.rlgck1,1,99,tp)
	local b2=g2:CheckSubGroup(c11513045.rlgck2,1,6,tp) 
	if (b1 or b2) and sg:GetCount()>0 then 
		local tc=sg:Select(tp,1,1,nil):GetFirst()   
		local mat=Group.CreateGroup() 
		local emat=Group.CreateGroup() 
		if b1 and b2 then 
			local op=Duel.SelectOption(tp,aux.Stringid(11513045,1),aux.Stringid(11513045,2),aux.Stringid(11513045,3)) 
			if op==0 then 
				mat=g1:SelectSubGroup(tp,c11513045.rlgck1,false,1,99,tp) 
			elseif op==1 then 
				mat=g2:SelectSubGroup(tp,c11513045.rlgck2,false,1,6,tp) 
			elseif op==2 then 
				mat=g1:SelectSubGroup(tp,c11513045.rlgck1,false,1,99,tp) 
				emat=g2:SelectSubGroup(tp,c11513045.rlgck2,false,1,6,tp) 
				mat:Merge(emat)
			end 
		elseif b1 then 
			mat=g1:SelectSubGroup(tp,c11513045.rlgck1,false,1,99,tp) 
		elseif b2 then 
			mat=g2:SelectSubGroup(tp,c11513045.rlgck2,false,1,6,tp) 
		end  
		tc:SetMaterial(mat) 
		local emat=mat:Filter(Card.IsLocation,nil,LOCATION_GRAVE) 
		mat:Sub(emat) 
		if emat:GetCount()>0 then 
			Duel.Remove(emat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL) 
		end  
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)  
		tc:CompleteProcedure()  
	end 
end
function c11513045.xctfil(c,tp) 
	return c:IsAbleToDeckAsCost() and c:IsCode(11513043) and Duel.IsExistingMatchingCard(c11513045.xtdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c)
end 
function c11513045.xtdfil(c) 
	return c:IsType(TYPE_RITUAL+TYPE_XYZ+TYPE_SYNCHRO+TYPE_LINK+TYPE_FUSION+TYPE_PENDULUM) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()  
end 
function c11513045.tdrcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(c11513045.xctfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler(),tp) end 
	local g=Duel.SelectMatchingCard(tp,c11513045.xctfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler(),tp)
	g:AddCard(e:GetHandler()) 
	Duel.SendtoDeck(g,nil,2,REASON_COST) 
end 
function c11513045.tdgck(g)  
	return g:FilterCount(Card.IsType,nil,TYPE_RITUAL)<=1 
	   and g:FilterCount(Card.IsType,nil,TYPE_XYZ)<=1 
	   and g:FilterCount(Card.IsType,nil,TYPE_SYNCHRO)<=1 
	   and g:FilterCount(Card.IsType,nil,TYPE_LINK)<=1 
	   and g:FilterCount(Card.IsType,nil,TYPE_FUSION)<=1 
	   and g:FilterCount(Card.IsType,nil,TYPE_PENDULUM)<=1  
end
function c11513045.tdrtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local g=Duel.GetMatchingGroup(c11513045.xtdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chk==0 then return g:CheckSubGroup(c11513045.tdgck,1,99) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end 
function c11513045.tdrop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11513045.xtdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if g:CheckSubGroup(c11513045.tdgck,1,99) then 
		local sg=g:SelectSubGroup(tp,c11513045.tdgck,false,1,99)
		local x=Duel.SendtoDeck(sg,nil,2,REASON_EFFECT) 
		local d=math.floor(x/3) 
		if d>0 and Duel.IsPlayerCanDraw(tp,d) then 
		Duel.BreakEffect() 
		Duel.Draw(tp,d,REASON_EFFECT)  
		end  
	end 
end 








