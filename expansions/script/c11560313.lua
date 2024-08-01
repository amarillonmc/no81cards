--次元极龙 巴哈姆特
function c11560313.initial_effect(c)
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--redirect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e0) 
	--SpecialSummon
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_PHASE+PHASE_END)  
	e1:SetRange(LOCATION_DECK)
	e1:SetCountLimit(1)  
	e1:SetCondition(c11560313.spcon) 
	e1:SetOperation(c11560313.spop) 
	c:RegisterEffect(e1) 
	--destroy all
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13331639,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,11560313+EFFECT_COUNT_CODE_DUEL) 
	e2:SetTarget(c11560313.destg)
	e2:SetOperation(c11560313.desop)
	c:RegisterEffect(e2) 
	--Destroy and SpecialSummon
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetRange(LOCATION_HAND+LOCATION_REMOVED)  
	e3:SetCountLimit(1,21560313)  
	e3:SetCost(c11560313.dspcost) 
	e3:SetTarget(c11560313.dsptg) 
	e3:SetOperation(c11560313.dspop) 
	c:RegisterEffect(e3)
	if not c11560313.global_check then 
		c11560313.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c11560313.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
c11560313.SetCard_XdMcy=true 
function c11560313.checkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tp=c:GetOwner()
	local tc=eg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tp,11560313,0,0,1)
		tc=eg:GetNext()
	end
end   
function c11560313.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetFlagEffect(tp,11560313)>=50 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false)
end 
function c11560313.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.GetFlagEffect(tp,11560313)>=50 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(11560313,0)) then 
	Duel.Hint(HINT_CARD,0,11560313)   
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end 
end 
function c11560313.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if chk==0 then return g:GetCount()>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>5 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,1-tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c11560313.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)-5 
	if ct>0 then 
		local rg=Duel.GetDecktopGroup(1-tp,ct)
		Duel.SendtoGrave(rg,REASON_EFFECT) 
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE) 
		e2:SetTargetRange(0,1)
		rg:KeepAlive()  
		e2:SetLabelObject(rg)
		e2:SetValue(c11560313.actlimit) 
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp) 
		local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
		if g:GetCount()>0 then 
			Duel.BreakEffect()
			Duel.Destroy(g,REASON_EFFECT) 
		end
	end
end
function c11560313.actlimit(e,re,tp) 
	local rg=e:GetLabelObject()
	return rg:IsExists(Card.IsOriginalCodeRule,1,nil,re:GetHandler():GetOriginalCodeRule()) 
end
function c11560313.dspcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end 
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end 
function c11560313.dspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(4) 
end 
function c11560313.actfilter(c) 
	return c:IsAttackBelow(2400) or c:IsDefenseBelow(2400)
end 
function c11560313.dsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11560313.actfilter,tp,0,LOCATION_MZONE,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE) 
end 
function c11560313.dspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c11560313.actfilter,tp,0,LOCATION_MZONE,nil) 
	local g2=Duel.GetMatchingGroup(c11560313.dspfil,tp,LOCATION_HAND,0,nil,e,tp)
	if g1:GetCount()<=0 then return end 
	local dg=g1:Select(tp,1,1,nil)  
	Duel.Destroy(dg,REASON_EFFECT) 
	--if g2:GetCount()<=0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return --end 
	--if Duel.SelectYesNo(tp,aux.Stringid(11560313,0)) then 
	--Duel.BreakEffect()
	--local sg=g2:Select(tp,1,1,nil)  
	--  Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)  
	--end 
end 






