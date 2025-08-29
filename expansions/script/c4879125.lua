local m=4879125
local cm=_G["c"..m]
function cm.initial_effect(c)
	 local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(cm.reptg)
	e2:SetValue(cm.repval)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.smtg)
	e3:SetOperation(cm.smop)
	c:RegisterEffect(e3)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
end
function cm.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xae51) and c:IsType(TYPE_MONSTER)
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave() and eg:IsExists(cm.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end
function cm.thfilter(c)
	return c:IsSetCard(0xae51) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function cm.aufilter(c)
	return c:IsSetCard(0x1b9) or c:IsType(TYPE_NORMAL)
end
function cm.atkval(e)
	local g=Duel.GetMatchingGroup(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,TYPE_NORMAL)
	return g:GetClassCount(Card.GetCode)*300
end
function cm.smfilter(c,e,tp)
	return bit.band(c:GetOriginalType(),TYPE_NORMAL)~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.tfilter(c,e,tp)
	return c:IsSetCard(0xae51) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.bfilter(c,tc)
	return c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)
end
function cm.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.tfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.smop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0  then
Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	Duel.SpecialSummonComplete()
	   local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end

end
function cm.actlimit(e,re,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsSetCard(0xae51)
end
