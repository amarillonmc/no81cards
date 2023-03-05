--电子龙 集束体
local m=39251701
local cm=_G["c"..m]
function cm.initial_effect(c)
		--code
		aux.EnableChangeCode(c,70095154,LOCATION_MZONE+LOCATION_GRAVE)
		--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,m)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_MOVE)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCountLimit(1,39252701)
	e2:SetCondition(cm.shcon)
	e2:SetTarget(cm.shtg)
	e2:SetOperation(cm.shop)
	c:RegisterEffect(e2)
end
function cm.mfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x1093) and c:IsLevelBelow(4)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK+LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.mfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.mfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)--till then end of the turn, the number is not 0, next turn, the number is 0 again.
	end
end
function cm.shcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(tp,m)~=0 and 
	c:IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_XYZ)
		and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function cm.shfilter(c)
	return (c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsSetCard(0x93) or c:IsSetCard(0x94))) 
	or c:IsCode(10045474) or c:IsCode(37630732) or c:IsCode(23171610)
end
function cm.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.shfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SEARCH+CATEGORY_DRAW,nil,1,tp,LOCATION_DECK)
end
function cm.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.shfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then 
	Duel.SendtoHand(g,tp,REASON_EFFECT) end
end
