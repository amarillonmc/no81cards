--云魔物-巨大喷流
local m=11451697
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,nil,2,2)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetCondition(cm.adcon)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--Remove counter replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_RCOUNTER_REPLACE+0x1019)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.rcon)
	e3:SetOperation(cm.rop)
	c:RegisterEffect(e3)
end
function cm.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,2) or c:IsSetCard(0x18)
end
function cm.filter(c)
	return not c:IsLevel(2)
end
function cm.adcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(cm.filter,1,nil)
end
function cm.atkval(e,c)
	return c:GetBaseAttack()*2
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x18) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1019,1,REASON_EFFECT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if Duel.RemoveCounter(tp,1,0,0x1019,1,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,1)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c)
	return not c:IsSetCard(0x18) and c:IsLocation(LOCATION_HAND+LOCATION_GRAVE)
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	local og=e:GetHandler():GetOverlayGroup()
	return ep==e:GetOwnerPlayer() and og and og:FilterCount(cm.filter,nil)>=ev
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	local og=e:GetHandler():GetOverlayGroup():Filter(cm.filter,nil)
	e:GetHandler():RemoveOverlayCard(ep,ev,ev,REASON_EFFECT)
end