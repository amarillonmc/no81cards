--特务忍兽 黄鼬
local m=40010513
local cm=_G["c"..m]
cm.named_with_SpecialStealthBeast=1
function cm.SpecialStealthBeast(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_SpecialStealthBeast
end
function cm.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1) 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.eftg)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)	   
end
function cm.eftg(e,c)
	return cm.SpecialStealthBeast(c) and c:IsType(TYPE_MONSTER) and not c:IsCode(m)
end
function cm.filter1(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function cm.filter(c,e,tp)
	return cm.SpecialStealthBeast(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end