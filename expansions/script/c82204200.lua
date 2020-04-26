local m=82204200
local cm=_G["c"..m]
cm.name="吉良吉影"
function cm.initial_effect(c)
	--set  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_MONSTER_SSET)  
	e1:SetValue(TYPE_SPELL)  
	c:RegisterEffect(e1)
	--Activate  
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_ACTIVATE)  
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.tg)  
	e2:SetOperation(cm.op)  
	c:RegisterEffect(e2) 
	--destroy
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_DESTROY)  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e3:SetCode(EVENT_SUMMON_SUCCESS)  
	e3:SetProperty(EFFECT_FLAG_DELAY)  
	e3:SetCountLimit(1,m)  
	e3:SetTarget(cm.destg)  
	e3:SetOperation(cm.desop)  
	c:RegisterEffect(e3)  
	local e4=e3:Clone()  
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)  
	c:RegisterEffect(e4)  
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return c:IsLocation(LOCATION_SZONE) and c:IsType(TYPE_SPELL) and c:IsFacedown() and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0  
end  
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) then return end  
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)  
end  
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end  
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
end  
function cm.desop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.HintSelection(g)  
		Duel.Destroy(g,REASON_EFFECT)  
	end  
end  