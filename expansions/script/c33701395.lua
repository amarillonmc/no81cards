--电拟神召·隐
local m=33701395
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
end
function cm.filter(c,att)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and c:GetAttribute()&att~=0
end
function cm.cfilter(c,e,tp)
	return c:IsSetCard(0x445) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsPublic() and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,2,nil,c:GetAttribute())
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	e:SetLabelObject(g:GetFirst())
	Duel.ConfirmCards(g,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetLabelObject() then e:SetTargetCard(e:GetLabelObject()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetLabelObject(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if not (c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e)) then return end
	local mat1=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,2,2,nil,tc:GetAttribute())
	tc:SetMaterial(mat1)
	if tc:IsType(TYPE_XYZ) and Duel.SelectYesNo(aux.Stringid(m,0)) then
		Duel.Overlay(tc,mat1)
	else
		Duel.Remove(mat1,POS_FACEDOWN,REASON_EFFECT+REASON_MATERIAL)
	end
	Duel.BreakEffect()
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
