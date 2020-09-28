--奇迹的D
function c9981065.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9981065+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9981065.cost)
	e1:SetTarget(c9981065.target)
	e1:SetOperation(c9981065.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c9981065.reptg)
	e2:SetValue(c9981065.repval)
	e2:SetOperation(c9981065.repop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(9981065,ACTIVITY_SUMMON,c9981065.counterfilter)
	Duel.AddCustomActivityCounter(9981065,ACTIVITY_SPSUMMON,c9981065.counterfilter)
end
function c9981065.counterfilter(c)
	return c:IsSetCard(0x8) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c9981065.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(9981065,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(9981065,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9981065.sumlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c9981065.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsSetCard(0x8) and c:IsAttribute(ATTRIBUTE_DARK))
end
function c9981065.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9981076,0xc008,0x4011,1900,600,8,RACE_WARRIOR,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c9981065.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9981076,0xc008,0x4011,1900,600,8,RACE_WARRIOR,ATTRIBUTE_DARK) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,9981076)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981065,0))
end
function c9981065.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSummonLocation()==LOCATION_EXTRA and c:IsSetCard(0xc008)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c9981065.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c9981065.repfilter,1,nil,tp) and e:GetHandler():IsAbleToRemove() end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c9981065.repval(e,c)
	return c9981065.repfilter(c,e:GetHandlerPlayer())
end
function c9981065.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end

