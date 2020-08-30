local m=82208134
local cm=_G["c"..m]
cm.name="龙法师 坚磐龙"
function cm.initial_effect(c)
	--to grave  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)  
	e1:SetCountLimit(1,m)  
	e1:SetTarget(cm.destg1)  
	e1:SetOperation(cm.desop1)  
	c:RegisterEffect(e1)  
	local e2=e1:Clone()  
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)  
	c:RegisterEffect(e2)  
	local e3=e1:Clone()  
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)  
	c:RegisterEffect(e3)  
	--recover  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_DESTROY)  
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e4:SetProperty(EFFECT_FLAG_DELAY)  
	e4:SetCode(EVENT_TO_GRAVE)  
	e4:SetCountLimit(1,m)  
	e4:SetTarget(cm.destg2)  
	e4:SetOperation(cm.desop2)  
	c:RegisterEffect(e4)  
end
function cm.destg1(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end  
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)  
end  
function cm.desop1(e,tp,eg,ep,ev,re,r,rp)  
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)  
	Duel.Destroy(sg,REASON_EFFECT)  
end  
function cm.filter(c)  
	return c:IsType(TYPE_SPELL+TYPE_TRAP)  
end  
function cm.destg2(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_ONFIELD,1,c) end  
	local sg=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_ONFIELD,c)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)  
end  
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)  
	local sg=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_ONFIELD,e:GetHandler())  
	Duel.Destroy(sg,REASON_EFFECT)  
end  