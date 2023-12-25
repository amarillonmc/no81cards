--人偶·剑灵青蒿
function c74571833.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c74571833.mfilter,c74571833.xyzcheck,2,2,c74571833.ovfilter,aux.Stringid(74571833,0),c74571833.xyzop)
	c:EnableReviveLimit()
	--xyzlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(74571833,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,74571833+74585399)
	e2:SetCondition(c74571833.thcon)
	e2:SetCost(c74571833.thcost)
	e2:SetTarget(c74571833.thtg)
	e2:SetOperation(c74571833.thop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(74571833,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,74571833)
	e3:SetCost(c74571833.spcost)
	e3:SetTarget(c74571833.sptg)
	e3:SetOperation(c74571833.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(74571833,3))
	e4:SetCost(c74571833.thcost)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(74571833,ACTIVITY_SPSUMMON,c74571833.counterfilter)
end
function c74571833.counterfilter(c)
	return c:IsSetCard(0x745)
end
function c74571833.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsXyzLevel(xyzc,4)
end
function c74571833.xyzcheck(g)
	return true
end
function c74571833.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x745)
end
function c74571833.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,74571833)==0 and Duel.GetCustomActivityCount(74571833,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.RegisterFlagEffect(tp,74571833,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c74571833.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c74571833.splimit(e,c)
	return not c:IsSetCard(0x745)
end
function c74571833.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c74571833.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST) 
end
function c74571833.thfilter(c)
	return c:IsSetCard(0x745) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c74571833.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c74571833.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c74571833.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c74571833.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c74571833.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c74571833.spfilter(c,e,tp)
	return c:IsSetCard(0x745) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c74571833.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c74571833.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c74571833.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c74571833.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
