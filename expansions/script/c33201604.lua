--御溟枢机的圣职者
local s,id,o=GetID()
function s.initial_effect(c)
	--grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--BE_MATERIAL
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(s.indcon)
	e3:SetOperation(s.indop)
	c:RegisterEffect(e3)
end
function s.spfilter(c,tp)
	return Duel.GetMZoneCount(tp)>0 and c:IsFaceup() and c:IsType(TYPE_MONSTER)
		and c:IsAbleToHand() and c:IsSetCard(0x5327)
end
function s.filter(c)
	return c:IsFaceup()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.spfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.spfilter,tp,LOCATION_MZONE,0,1,nil,tp) and not c:IsType(TYPE_TUNER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_ADD_TYPE)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		e0:SetValue(TYPE_TUNER)
		c:RegisterEffect(e0)
	end
	Duel.SpecialSummonComplete()
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
	else
		if Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
			local g=Duel.SelectMatchingCard(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
			if g:GetCount()>0 then
				Duel.HintSelection(g)
				local ec=g:GetFirst()
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_CANNOT_TRIGGER)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				ec:RegisterEffect(e2,true)
				ec:RegisterFlagEffect(0,RESET_EVENT+RESETS_REDIRECT+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
			end 
		end
	end
end
function s.indcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function s.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e2,true)
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
end
