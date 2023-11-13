--大龙大神
local m=116210101
local cm=_G["c"..m]
function c116210101.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1) 
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)   
end
--function cm.cfilter(c,tp)
  --  return c:IsSummonPlayer(1-tp)
--end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) --and eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) end
	local mp=eg:GetFirst():GetPreviousControler()
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,mp,LOCATION_EXTRA)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local mp=eg:GetFirst():GetPreviousControler()
	local tg=Duel.GetMatchingGroup(Card.IsAbleToGrave,mp,LOCATION_EXTRA,0,nil)
	if tg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,mp,HINTMSG_TOGRAVE)
	local g=tg:Select(mp,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end