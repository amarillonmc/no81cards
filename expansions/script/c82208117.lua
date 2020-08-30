local m=82208117
local cm=_G["c"..m]
cm.name="凶兽斗士"
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
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetCode(EFFECT_SSET_COST)  
	--e3:SetProperty()
	e3:SetRange(0xff)  
	e3:SetTarget(cm.costtg)
	e3:SetTargetRange(0xff,0xff)
	e3:SetCost(cm.costchk)  
	e3:SetOperation(cm.costop)  
	c:RegisterEffect(e3)  
end
function cm.costfilter(c)  
	return c:IsReleasable()
end  
function cm.con(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return c:IsLocation(LOCATION_SZONE) and c:IsType(TYPE_SPELL) and c:IsFacedown() and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
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
function cm.costtg(e,c)  
	return c==e:GetHandler()  
end  
function cm.costchk(e,te_or_c,tp) 
	return Duel.IsExistingMatchingCard(cm.costfilter,tp,0x0c,0x0c,1,nil) 
	and not e:GetHandler():IsPublic() 
	and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end  
function cm.costop(e,tp,eg,ep,ev,re,r,rp) 
	local ct=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)+1 
	Duel.ConfirmCards(1-tp,e:GetHandler()) 
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,0x0c,0x0c,1,ct,nil)  
	Duel.Release(g,REASON_COST) 
end  