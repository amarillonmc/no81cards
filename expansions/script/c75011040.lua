--熟练的炼金术师 莱莎琳·斯托特
function c75011040.initial_effect(c)
	aux.AddCodeList(c,46130346,5318639,12580477)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c75011040.mfilter,c75011040.xyzcheck,2,2,c75011040.ovfilter,aux.Stringid(75011040,0),c75011040.xyzop)
	--field effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISEFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c75011040.effectfilter)
	c:RegisterEffect(e1)
	--summon reg
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c75011040.regcon)
	e2:SetOperation(c75011040.regop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetHintTiming(0,TIMING_END)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,75011040)
	e3:SetCondition(c75011040.spcon)
	e3:SetCost(c75011040.spcost)
	e3:SetTarget(c75011040.sptg)
	e3:SetOperation(c75011040.spop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(75011040,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,75011041)
	e4:SetCondition(c75011040.thcon)
	e4:SetTarget(c75011040.thtg)
	e4:SetOperation(c75011040.thop)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(75011040,ACTIVITY_CHAIN,c75011040.chainfilter)
end
function c75011040.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	return not (re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsSetCard(0x75e))
end
function c75011040.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ) and c:IsSetCard(0x75e)
end
function c75011040.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end
function c75011040.ovfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c75011040.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,75011040)==0 and (Duel.GetCustomActivityCount(75011040,0,ACTIVITY_CHAIN)>0 or Duel.GetCustomActivityCount(75011040,1,ACTIVITY_CHAIN)>0) end
	Duel.RegisterFlagEffect(tp,75011040,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c75011040.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:IsActiveType(TYPE_SPELL)
end
function c75011040.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c75011040.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(75011040,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(75011040,3))
end
function c75011040.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(75011040)~=0
end
function c75011040.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c75011040.spfilter(c,e,tp)
	return c:IsSetCard(0x75e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75011040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	--local og=e:GetHandler():GetOverlayGroup()
	local ct=e:GetHandler():GetOverlayCount()
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return ct>0 and e:GetHandler():CheckRemoveOverlayCard(tp,ct,REASON_COST) and Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c75011040.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	e:GetHandler():RemoveOverlayCard(tp,ct,ct,REASON_COST)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,tp,LOCATION_GRAVE)
end
function c75011040.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local ct=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local ft=Duel.GetMZoneCount(tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c75011040.spfilter,tp,LOCATION_GRAVE,0,1,math.min(ft,ct),nil,e,tp)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c75011040.chkfilter(c,tp,rp)
	return c:IsPreviousControler(1-tp) and rp==tp
end
function c75011040.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75011040.chkfilter,1,nil,tp,rp)
end
function c75011040.thfilter(c)
	return c:IsCode(46130346,5318639,12580477) and c:IsAbleToHand()
end
function c75011040.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75011040.thfilter,tp,LOCATION_DECK+0x10,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c75011040.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c75011040.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=g:SelectSubGroup(tp,aux.dncheck,false,1,3)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
end
