--北岐大元帅 北统
local s,id,o=GetID()
function s.initial_effect(c)
	--特召限制
    local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--攻击力下降
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_F)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(s.atkcon)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)    
	--召唤    
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
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
	--祭品限制
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e4:SetCondition(s.sumrcon)
	e4:SetOperation(s.sumrop)
	e4:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_LIMIT_SET_PROC)
	e5:SetCondition(s.setrcon)
	c:RegisterEffect(e5)    
	--封锁
    local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,2))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCountLimit(1,id+o)
    e6:SetCondition(s.efcon1)
	e6:SetTarget(s.eftg)
	e6:SetOperation(s.efop)
	c:RegisterEffect(e6)
    local e7=e6:Clone()
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(s.efcon2)
	c:RegisterEffect(e7)        
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
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
    	and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE
        and re:GetHandler():IsRelateToEffect(re)
end      
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
    if rc:IsRelateToEffect(re) and rc:IsFaceup() then
    	local preatk=rc:GetAttack()
    	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e1)
        if preatk~=0 and rc:IsAttack(0) and rc:IsCanBeDisabledByEffect(e) then
        	Duel.NegateRelatedChain(rc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e2)
        end
    end
end
function s.efcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function s.efcon2(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler())
end
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetTarget(s.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
    local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
end    
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_ZOMBIE) and bit.band(sumtype,SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE
end
function s.sumrfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function s.sumrfilter0(c)
	return c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER)
end
function s.sumrcon(e,c,minc)
	if c==nil then return true end
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
	local ct=3
    local res=(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>=3
		or Duel.CheckTribute(c,1) and mg:GetCount()>=2 or Duel.CheckTribute(c,2) and mg:GetCount()>=1
        or Duel.CheckTribute(c,3))
	return minc<=3 and res
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
	local ct=3
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
function s.setrcon(e,c,minc)
	if not c then return true end
	return false
end