--桃绯术式 至暗巨像
function c9910522.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910522+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910522.target)
	e1:SetOperation(c9910522.activate)
	c:RegisterEffect(e1)
end
function c9910522.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa950) and c:IsAbleToHand() and Duel.GetMZoneCount(tp,c)>1
end
function c9910522.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c9910522.thfilter(chkc,tp) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c9910522.thfilter,tp,LOCATION_ONFIELD,0,1,c,tp)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9910523,0xa950,0x4011,1600,1600,4,RACE_ROCK,ATTRIBUTE_DARK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c9910522.thfilter,tp,LOCATION_ONFIELD,0,1,1,c,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c9910522.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9910523,0xa950,0x4011,1600,1600,4,RACE_ROCK,ATTRIBUTE_DARK) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,9910522+i)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(1)
			token:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UPDATE_ATTACK)
			e3:SetValue(c9910522.atkval)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e3,true)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_UPDATE_DEFENSE)
			token:RegisterEffect(e4,true)
		end
		Duel.SpecialSummonComplete()
	end
end
function c9910522.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa950) and c:IsStatus(STATUS_EFFECT_ENABLED)
		and not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function c9910522.atkval(e,c)
	local tp=c:GetControler()
	return Duel.GetMatchingGroupCount(c9910522.atkfilter,tp,LOCATION_ONFIELD,0,nil)*200
end
