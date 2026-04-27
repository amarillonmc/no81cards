--古旧天书·莲妥丝
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,11771980,11771990,11771995)
	--同调召唤
	c:EnableReviveLimit()
	--特召限制
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.splimit)
	c:RegisterEffect(e0)
	--破坏    
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--抗性 
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_SZONE+LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(s.efilter)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(s.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--改变效果
    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id+o)
	e4:SetCondition(s.chcon)
	e4:SetTarget(s.chtg)
	e4:SetOperation(s.chop)
	c:RegisterEffect(e4)   
end
function s.splimit(e,se,sp,st)
	return (se and se:GetHandler():IsCode(11771990)) or st&SUMMON_TYPE_SYNCHRO~=SUMMON_TYPE_SYNCHRO
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.penfilter(c,tp)
	return c:IsType(TYPE_CONTINUOUS) and c:IsCode(11771995) and not c:IsForbidden() 
    	and c:CheckUniqueOnField(tp) and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED))
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD):Select(tp,1,3,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)~=0 then
        	local og=Duel.GetOperatedGroup()
            if og:IsExists(Card.IsPreviousControler,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
				and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.penfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp)
                and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
                Duel.BreakEffect()
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
				local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.penfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp):GetFirst()
				if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
            end    
        end
	end        
end
function s.efilter(e,re,ev)
	if re:GetOwnerPlayer()==e:GetHandlerPlayer() or not re:IsActivated() then return false end
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end
function s.eftg(e,c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsFaceup()
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,rp,0,LOCATION_ONFIELD,1,nil) end
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.repop)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
    	Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end