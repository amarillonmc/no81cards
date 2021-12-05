local m=53718018
local cm=_G["c"..m]
cm.name="南华管理者"
function cm.initial_effect(c)
	aux.AddCodeList(c,53718001)
	aux.AddCodeList(c,53718002)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_SETCODE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(cm.con)
	e2:SetValue(0x453c)
	c:RegisterEffect(e2)
end
function cm.scfilter(c)
	return c:IsFaceup() and ((c:IsType(TYPE_MONSTER) and c:IsSetCard(0x353c)) or c:IsCode(53718006))
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.scfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function cm.fselect(g,c)
	return g:IsContains(c)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,nil)
	if chk==0 then return #g>1 end
	local sg=g:SelectSubGroup(tp,cm.fselect,false,2,2,c)
	Duel.SendtoGrave(sg,REASON_COST)
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0x653c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.cfilter(c)
	return c:IsCode(53718001,53718002)
end
function cm.con(e)
	return Duel.IsExistingMatchingCard(cm.cfilter,e:GetHandler():GetControler(),LOCATION_GRAVE,0,1,nil)
end
