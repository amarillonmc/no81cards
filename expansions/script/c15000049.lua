local m=15000049
local cm=_G["c"..m]
cm.name="色带霜风·伊塔库亚"
function cm.initial_effect(c)
	--link summon  
	aux.AddLinkProcedure(c,nil,2,99,cm.lcheck)  
	c:EnableReviveLimit()
	--Pzone Set
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m) 
	e1:SetCondition(cm.tgcon)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	--summon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1f33))
	e2:SetTargetRange(LOCATION_MZONE,0)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	c:RegisterEffect(e3)
end
function cm.lcheck(g,lc)  
	return g:IsExists(cm.hspfilter,1,nil)  
end
function cm.hspfilter(c)
	return c:IsLinkType(TYPE_PENDULUM) and c:IsLinkType(TYPE_MONSTER)
end
function cm.filter1(c,tp)  
	return c:IsType(TYPE_PENDULUM) and (c:IsFaceup() or c:IsLocation(LOCATION_DECK)) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,c,c:GetLeftScale(),c:GetCode())  
end  
function cm.filter2(c,sc,cd)  
	return c:IsType(TYPE_PENDULUM) and (c:IsFaceup() or c:IsLocation(LOCATION_DECK)) and (c:GetLeftScale()==sc or c:GetLeftScale()==sc+1 or c:GetLeftScale()==sc-1) and not c:IsCode(cd)  
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_PZONE,0,nil,tp)
	if g:GetCount()==0 then 
		local ag=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,tp)
		if ag:GetCount()==0 then return false end
	end
	if g:GetCount()==2 then return false end
	if g:GetCount()==1 then
		local tc=g:GetFirst()
		local bg=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,tc:GetLeftScale(),tc:GetCode())
		if bg:GetCount()==0 then return false end
	end
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_PZONE,0,nil,tp)
	if g:GetCount()==0 then 
		local ag=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,tp)
		if ag:GetCount()~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
			local tc1=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,tp):GetFirst()
			if not tc1 then return end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
			local tc2=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,tc1,tc1:GetLeftScale(),tc1:GetCode()):GetFirst()
			Duel.MoveToField(tc1,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			Duel.MoveToField(tc2,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
	if g:GetCount()==1 then
		local tc=g:GetFirst()
		local bg=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,tc:GetLeftScale(),tc:GetCode())
		if bg:GetCount()~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
			local tc3=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,tc,tc:GetLeftScale(),tc:GetCode()):GetFirst()
			Duel.MoveToField(tc3,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
	if g:GetCount()==2 then 
		local tc=g:GetFirst()
	end
	local e3=Effect.CreateEffect(e:GetHandler())  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e3:SetTargetRange(1,0)  
	e3:SetTarget(cm.splimit)  
	e3:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e3,tp)
end
function cm.splimit(e,c)  
	return not c:IsRace(RACE_FIEND) 
end 