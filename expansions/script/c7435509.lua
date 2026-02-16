--叛骨之镇法
local s,id,o=GetID()
--string
s.named_with_Rebellion_Skull=1
--s.named_with_Skullize=1
--SETCARD_REBELLION_SKULL =0xdce
--SETCARD_SKULLIZE =0xdce
--string check
function s.Rebellion_Skull(c)
	local m=_G["c"..c:GetCode()]
	return (m and m.named_with_Rebellion_Skull) or (SETCARD_REBELLION_SKULL and c:IsSetCard(SETCARD_REBELLION_SKULL))
end
function s.Skullize(c)
	local m=_G["c"..c:GetCode()]
	return (m and m.named_with_Skullize) or (SETCARD_SKULLIZE and c:IsSetCard(SETCARD_SKULLIZE))
end
--
function s.initial_effect(c)
	aux.AddCodeList(c,7435501)
	--change code
	aux.EnableChangeCode(c,7435501,LOCATION_GRAVE)
	--summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(s.sumcon)
	e0:SetTarget(s.sumtarget)
	e0:SetOperation(s.sumactivate)
	c:RegisterEffect(e0)
	--
	--lv change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(s.lvop)
	c:RegisterEffect(e3)
end
function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return false end
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function s.sumtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSummonable(true,nil) end
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
end
function s.sumactivate(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(id)
	if e:GetHandler():IsSummonable(true,nil) then
		Duel.Summon(tp,e:GetHandler(),true,nil)
	end
end
function s.thorspfilter(c,e,tp)
	if not c:IsCode(7435501) or not c:IsLevel(5) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.thorspfilter),tp,LOCATION_GRAVE,0,1,nil,e,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local gg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thorspfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
			local hc=gg:GetFirst()
			if hc then
				if hc:IsAbleToHand() and (not hc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
					Duel.SendtoHand(hc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,hc)
				else
					Duel.SpecialSummon(hc,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end
