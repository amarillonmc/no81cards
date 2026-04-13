--斗神 诺托斯
local s,id,o=GetID()
function s.initial_effect(c)
	--同调召唤
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),aux.NonTuner(s.matfilter),1)
	c:EnableReviveLimit()
	--赋予抗性    
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(s.immcon)
	e1:SetTarget(s.immtg)
	e1:SetOperation(s.immop)
	c:RegisterEffect(e1)
	--改变效果    
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)	
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.chcon)
	e2:SetTarget(s.chtg)
	e2:SetOperation(s.chop)
	c:RegisterEffect(e2)
	--送去墓地    
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+o)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(s.tgtg)
	e3:SetOperation(s.tgop)
	c:RegisterEffect(e3)
end
function s.matfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsType(TYPE_SYNCHRO)
end
function s.immcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.immtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
    Duel.SetChainLimit(aux.FALSE)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.immop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISEFFECT)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(s.effilter)
	e1:SetReset(RESET_PHASE+PHASE_END,3)
	Duel.RegisterEffect(e1,tp)
    local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DISABLE)
	Duel.RegisterEffect(e2,tp)
end
function s.effilter(e,ct)
	local te,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_LOCATION)
	return te:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE 
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep==1-tp and loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsPosition(POS_FACEUP_ATTACK)
    	and e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAttackable() and Duel.IsExistingMatchingCard(Card.IsFaceup,rp,0,LOCATION_MZONE,1,Duel.GetAttackTarget()) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.repop)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(Card.GetAttack)
    if tg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=tg:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.CalculateDamage(c,sg:GetFirst())
	else 
    	Duel.CalculateDamage(c,tg:GetFirst())
    end
end
function s.tgfilter(c,tp)
	return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end    
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)
	if chk==0 then return ct>2 and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) 
    	and Duel.IsExistingMatchingCard(s.tgfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_MZONE)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    if g:GetCount()>2 and g:FilterCount(Card.IsControler,nil,tp)>0 and g:FilterCount(Card.IsControler,nil,1-tp)>0 then
    	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    	local sg1=g:FilterSelect(tp,Card.IsControler,1,1,nil,tp)
        if sg1:GetCount()==0 then return end
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TARGET)
    	local sg2=g:FilterSelect(1-tp,Card.IsControler,1,1,nil,1-tp)
        if sg2:GetCount()==0 then return end
        sg1:Merge(sg2)
        Duel.HintSelection(sg1)
        local tg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_MZONE,LOCATION_MZONE,sg1)
        if tg:GetCount()==0 then return end
        Duel.SendtoGrave(tg,REASON_EFFECT)
    end
end