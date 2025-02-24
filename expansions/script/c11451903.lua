--迷托邦道引 迷心
local cm,m=GetID()
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=c:GetLocation()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if loc&LOCATION_GRAVE>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e1:SetValue(LOCATION_REMOVED)
			c:RegisterEffect(e1)
		end
	end
end
function cm.thfilter(c)
	return c:IsSetCard(0xc976) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and (c:IsFaceup() or c:IsLocation(LOCATION_DECK))
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) and c:GetFlagEffect(m)==0 end
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	c:RegisterFlagEffect(m,RESET_EVENT+0x4620000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		local code=g:GetFirst():GetCode()
		if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,g)
			--selfdes
			local e7=Effect.CreateEffect(c)
			e7:SetType(EFFECT_TYPE_FIELD)
			e7:SetCode(EFFECT_SELF_DESTROY)
			e7:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
			e7:SetLabel(code)
			e7:SetCondition(cm.sdcon)
			e7:SetTarget(cm.sdtg)
			--Duel.RegisterEffect(e7,tp)
			local e8=Effect.CreateEffect(c)
			e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e8:SetCode(EVENT_ADJUST)
			e8:SetLabel(code)
			e8:SetCondition(function() return not pnfl_adjusting end)
			e8:SetOperation(cm.sdop)
			Duel.RegisterEffect(e8,tp)
			if Duel.GetFlagEffect(tp,code+0xffffff)==0 then
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(code,4))
				e1:SetCode(code+0xffffff+EFFECT_FLAG_EFFECT)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
				e1:SetTargetRange(1,0)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function cm.sdcon(e)
	return not Duel.IsExistingMatchingCard(cm.cfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e:GetLabel())
end
function cm.cfilter(c,code)
	return c:IsCode(code) and c:IsFaceup()
end
function cm.cfilter2(c,code,e)
	return c:IsCode(code) and c:IsFaceup() and not c:IsStatus(STATUS_BATTLE_DESTROYED) and not c:IsImmuneToEffect(e) and not c:IsHasEffect(EFFECT_INDESTRUCTABLE) and not c:IsHasEffect(EFFECT_INDESTRUCTABLE_EFFECT)
end
function cm.sdtg(e,c)
	return c:IsCode(m) and c:IsFaceup()
end
function cm.sdop(e,tp,eg,ep,ev,re,r,rp)
	pnfl_adjusting=true
	local phase=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then pnfl_adjusting=false return end
	local sdg=Duel.GetMatchingGroup(cm.cfilter2,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,m,e)
	if #sdg>0 and cm.sdcon(e) and Duel.Destroy(sdg,REASON_EFFECT) then
		local sdg=Duel.GetMatchingGroup(cm.cfilter2,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,m,e)
		if #sdg>0 and cm.sdcon(e) then pnfl_adjusting=false Duel.Readjust() end
	end
	pnfl_adjusting=false
end