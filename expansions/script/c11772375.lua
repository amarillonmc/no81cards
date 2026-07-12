--北岐冥后 北幽
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,11772385)
	--特召限制
    local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--卡组检索    
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_HANDES_SELF)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)    
	--进行召唤    
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
    e2:SetCondition(s.sumcon)
	e2:SetCost(s.sumcost)
	e2:SetTarget(s.sumtg)
	e2:SetOperation(s.sumop)
	c:RegisterEffect(e2)   
	--适用效果    
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(s.eftg)
	e3:SetOperation(s.efop)
	c:RegisterEffect(e3)
	--召唤规则    
    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,6))
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SUMMON_PROC)
	e4:SetCondition(s.sumrcon)
	e4:SetOperation(s.sumrop)
	e4:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_SET_PROC)
    c:RegisterEffect(e5)
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function s.thfilter(c)
	return c:IsSetCard(0x6c75) and c:IsLevelBelow(8) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local dg=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil,REASON_EFFECT)
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
		end
	end
end
function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetActivityCount(1-tp,ACTIVITY_SPSUMMON)>0
end
function s.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0 end
	Duel.Release(c,REASON_COST)
end
function s.sumfilter(c)
	return c:IsSetCard(0x6c75) and c:IsSummonable(true,nil)
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSummon(tp) and Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.sumfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function s.actfilter(c,tp)
	return c:IsCode(11772385) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function s.sthfilter(c)
	return c:IsSetCard(0x6c75) and (c:GetType()==TYPE_SPELL or c:IsType(TYPE_QUICKPLAY)) and c:IsAbleToHand()
end
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.actfilter,tp,LOCATION_DECK,0,1,nil,tp)
    local b2=Duel.IsExistingMatchingCard(s.sthfilter,tp,LOCATION_DECK,0,1,nil)    
	if chk==0 then return (b1 or b2) end
    if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(s.actfilter,tp,LOCATION_DECK,0,1,nil,tp)
    local b2=Duel.IsExistingMatchingCard(s.sthfilter,tp,LOCATION_DECK,0,1,nil)    
    if not b1 and not b2 then return end
    local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,4),1},
		{b2,aux.Stringid(id,5),2})
    if op==1 then
    	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,7))
		if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
		local tc=Duel.SelectMatchingCard(tp,s.actfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		Duel.ResetFlagEffect(tp,15248873)
		if tc then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
    elseif op==2 then
    	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.sthfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
    end
end
function s.sumrfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function s.sumrfilter0(c)
	return c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER)
end
function s.sumrcon(e,c,minc)
	if c==nil then return true end
	if c:IsLevelBelow(4) then return end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(s.sumrfilter,tp,LOCATION_GRAVE,0,nil)
    local mg0=Group.CreateGroup()
    if Duel.IsPlayerAffectedByEffect(tp,11772390) then
		local g1=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,0,LOCATION_ONFIELD,nil)
        mg0:Merge(g1)
    end
    if Duel.IsPlayerAffectedByEffect(tp,11772391) then
		local g2=Duel.GetMatchingGroup(s.sumrfilter0,tp,LOCATION_EXTRA,0,nil)
        mg0:Merge(g2)    
    end
    mg:Merge(mg0)
	local ct=2 
	local res=(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>=2
		or Duel.CheckTribute(c,1) and mg:GetCount()>=1
		or Duel.CheckTribute(c,2))
	if c:IsLevelBelow(6) then 
		ct=1 
		res=(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>=1
		or Duel.CheckTribute(c,1))
	end
	return minc<=ct and res
end
function s.sumrop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(s.sumrfilter,tp,LOCATION_GRAVE,0,nil)
    local mg1=Group.CreateGroup()
	local mg2=Group.CreateGroup()
    if Duel.IsPlayerAffectedByEffect(tp,11772390) then
		mg1=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,0,LOCATION_ONFIELD,nil)
    end
    if Duel.IsPlayerAffectedByEffect(tp,11772391) then
    	mg2=Duel.GetMatchingGroup(s.sumrfilter0,tp,LOCATION_EXTRA,0,nil)
    end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Group.CreateGroup()
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
    local g3=Group.CreateGroup()
	local ct=2 
	if c:IsLevelBelow(6) then ct=1 end
    for i=1,ct do
		if mg:GetCount()>0 and (ct>1 and Duel.CheckTribute(c,ct-1) or ct>0 and ft>0)
			and (not Duel.CheckTribute(c,ct) and not (Duel.IsPlayerAffectedByEffect(tp,11772390)
            and mg1:GetCount()>0) and not (Duel.IsPlayerAffectedByEffect(tp,11772391) and mg2:GetCount()>0)
            or Duel.SelectYesNo(tp,aux.Stringid(id,3))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local tg=mg:Select(tp,1,1,nil)
			g1:Merge(tg)
			mg:Sub(tg)
			ct=ct-1
		end
    	if mg1:GetCount()>0 and (ct>1 and Duel.CheckTribute(c,ct-1) or ct>0 and ft>0)
			and (not Duel.CheckTribute(c,ct) and not (Duel.IsPlayerAffectedByEffect(tp,11772391) 
            and mg2:GetCount()>0) or Duel.SelectYesNo(tp,aux.Stringid(11772390,5))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local tg1=mg1:Select(tp,1,1,nil)
			g1:Merge(tg1)
			mg1:Sub(tg1)
			ct=ct-1
       	 	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		end
    	if mg2:GetCount()>0 and (ct>1 and Duel.CheckTribute(c,ct-1) or ct>0 and ft>0)
			and (not Duel.CheckTribute(c,ct) or Duel.SelectYesNo(tp,aux.Stringid(11772390,6))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tg2=mg2:Select(tp,1,1,nil)
			g3:Merge(tg2)
			mg2:Sub(tg2)
			ct=ct-1
		end        		
    end    
    if g:GetCount()<ct then
		local sg=Duel.SelectTribute(tp,c,ct-g:GetCount(),ct-g:GetCount())
		g2:Merge(sg)            
	end
	g:Merge(g1)
	g:Merge(g2)
    g:Merge(g3)
	c:SetMaterial(g)
	if g1:GetCount()>0 then 
		Duel.Remove(g1,POS_FACEUP,REASON_SUMMON+REASON_MATERIAL)
        if Duel.GetFlagEffect(tp,id)>0 then
        	Duel.IsPlayerAffectedByEffect(tp,11772390):UseCountLimit(tp)
            Duel.ResetFlagEffect(tp,id)
        end
	end
	if g2:GetCount()>0 then
		Duel.Release(g2,REASON_SUMMON+REASON_MATERIAL)
	end
    if g3:GetCount()>0 then
    	Duel.SendtoGrave(g3,REASON_SUMMON+REASON_MATERIAL)
        Duel.IsPlayerAffectedByEffect(tp,11772391):UseCountLimit(tp)
    end
end