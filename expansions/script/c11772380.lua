--北岐巡游 北冥
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
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.tgcost)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	--送去墓地    
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+o)
    e2:SetCondition(s.bhcon)
	e2:SetTarget(s.bttg)
	e2:SetOperation(s.btop)
	c:RegisterEffect(e2)
	--召唤规则    
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11772390,4))
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetCondition(s.sumrcon)
	e3:SetOperation(s.sumrop)
	e3:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_SET_PROC)
    c:RegisterEffect(e4)       
end
function s.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardDeck(tp,3,REASON_EFFECT)~=0 then
    	local oc=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
    	if oc>0 and Duel.IsExistingMatchingCard(Card.IsSummonType,tp,LOCATION_MZONE,0,1,nil,SUMMON_TYPE_ADVANCE)
        	and Duel.GetMatchingGroupCount(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)>0
            and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
        	Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
            local tg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil):Select(tp,1,1,nil)
            if tg:GetCount()>0 then
            	Duel.HintSelection(tg)
                Duel.SendtoGrave(tg,REASON_EFFECT)
            end
        end
    end
    local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function s.bhcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
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
                and Duel.GetMatchingGroupCount(Card.IsAbleToGrave,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)>0 then
                Duel.BreakEffect()
                Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
				local tg=Duel.GetMatchingGroup(Card.IsAbleToGrave,1-tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil):Select(1-tp,1,1,nil)
                Duel.HintSelection(tg)
				Duel.SendtoGrave(tg,REASON_RULE,1-tp)
            end    	
		end
	end
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
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