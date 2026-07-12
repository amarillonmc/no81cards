--北岐噬兽
local s,id,o=GetID()
function s.initial_effect(c)
	--特召限制
    local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--送去墓地    
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id+o)
	e1:SetTarget(s.bttg)
	e1:SetOperation(s.btop)
	c:RegisterEffect(e1)
	--召唤    
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.sumcon1)
	e2:SetTarget(s.sumtg)
	e2:SetOperation(s.sumop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(s.sumcon2)
	c:RegisterEffect(e3)
	--召唤规则    
    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11772390,4))
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
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
function s.sumcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsSummonType,tp,LOCATION_MZONE,0,1,nil,SUMMON_TYPE_ADVANCE)
    	and not Duel.IsExistingMatchingCard(Card.IsSummonType,tp,LOCATION_MZONE,0,1,nil,SUMMON_TYPE_SPECIAL)
end
function s.sumcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSummonType,tp,LOCATION_MZONE,0,1,nil,SUMMON_TYPE_ADVANCE)
    	and not Duel.IsExistingMatchingCard(Card.IsSummonType,tp,LOCATION_MZONE,0,1,nil,SUMMON_TYPE_SPECIAL)
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSummonable(true,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Summon(tp,c,true,nil)
	end
end
function s.bttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.btop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	if c:IsRelateToEffect(e) then
		if c:IsAbleToHand() and Duel.SelectOption(tp,1190,1191)==0 then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		else
			if Duel.SendtoGrave(c,REASON_EFFECT+REASON_RETURN)~=0 and c:IsLocation(LOCATION_GRAVE) 
                and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil)       
                and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
                Duel.BreakEffect()
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
				if g:GetCount()>0 then
                	Duel.BreakEffect()
                    Duel.HintSelection(g)
                    Duel.SendtoGrave(g,REASON_EFFECT)
                end
            end    	
		end
	end
end
function s.sumrfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER)
end
function s.sumrcon(e,c,minc)
	if c==nil then return true end
	if c:IsLevelBelow(4) then return end    
	local tp=c:GetControler()
    if not Duel.IsPlayerAffectedByEffect(tp,11772390) and not Duel.IsPlayerAffectedByEffect(tp,11772391) then return end
    local mg=Group.CreateGroup()
    if Duel.IsPlayerAffectedByEffect(tp,11772390) then
		local g1=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,0,LOCATION_ONFIELD,nil)
        mg:Merge(g1)
    end
    if Duel.IsPlayerAffectedByEffect(tp,11772391) then
		local g2=Duel.GetMatchingGroup(s.sumrfilter,tp,LOCATION_EXTRA,0,nil)
        mg:Merge(g2)    
    end    
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
	local mg1=Group.CreateGroup()
	local mg2=Group.CreateGroup()
    if Duel.IsPlayerAffectedByEffect(tp,11772390) then
		mg1=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,0,LOCATION_ONFIELD,nil)
    end
    if Duel.IsPlayerAffectedByEffect(tp,11772391) then
    	mg2=Duel.GetMatchingGroup(s.sumrfilter,tp,LOCATION_EXTRA,0,nil)
    end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Group.CreateGroup()
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
    local g3=Group.CreateGroup()
	local ct=2 
	if c:IsLevelBelow(6) then ct=1 end
    for i=1,ct do
		if mg1:GetCount()>0 and (ct>1 and Duel.CheckTribute(c,ct-1) or ct>0 and ft>0)
			and (not Duel.CheckTribute(c,ct) and not (Duel.IsPlayerAffectedByEffect(tp,11772391) and mg2:GetCount()>0) 
            or Duel.SelectYesNo(tp,aux.Stringid(11772390,5))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local tg1=mg1:Select(tp,1,1,nil)
			g1:Merge(tg1)
			mg1:Sub(tg1)
			ct=ct-1
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
        Duel.IsPlayerAffectedByEffect(tp,11772390):UseCountLimit(tp)
	end
	if g2:GetCount()>0 then
		Duel.Release(g2,REASON_SUMMON+REASON_MATERIAL)
	end
    if g3:GetCount()>0 then
    	Duel.SendtoGrave(g3,REASON_SUMMON+REASON_MATERIAL)
        Duel.IsPlayerAffectedByEffect(tp,11772391):UseCountLimit(tp)
    end
end