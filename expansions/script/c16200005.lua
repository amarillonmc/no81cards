--一般路过单推人
function c16200005.initial_effect(c)
	aux.AddCodeList(c,16200003)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,16200005)
	e1:SetCost(c16200005.cost)
	e1:SetCondition(c16200005.condition)
	e1:SetTarget(c16200005.target)
	e1:SetOperation(c16200005.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(c16200005.handcon)
	c:RegisterEffect(e0)
end
function c16200005.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c16200005.handcon(e)
	return not Duel.IsExistingMatchingCard(c16200005.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c16200005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SUMMON)==0
		and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c16200005.sumlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e3,tp)
end
function c16200005.condition(e,tp)
	return Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,0,nil)<Duel.GetMatchingGroupCount(nil,1-tp,LOCATION_MZONE,0,nil)
end
function c16200005.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return e:GetLabelObject()~=se
end
function c16200005.thfilter(c)
	return c:IsAbleToHand() and aux.IsCodeListed(c,16200003)
end
function c16200005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,0)
	if chk==0 then  
		local res=Duel.IsPlayerCanSpecialSummonMonster(tp,16200003,0,0x4011,0,0,1,RACE_WARRIOR,ATTRIBUTE_DARK) and Duel.IsExistingMatchingCard(c16200005.thfilter,tp,LOCATION_DECK,0,1,nil)
		if ct>1 then
			res=res and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		elseif ct==0 then
			res=false
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0,0)
end
function c16200005.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,0)
	if ct>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,16200003,0,0x4011,0,0,1,RACE_WARRIOR,ATTRIBUTE_DARK) then
		for i=1,ct do
			local token=Duel.CreateToken(tp,16200003)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			e2:SetValue(c16200005.fuslimit)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e2,true)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			e3:SetValue(1)
			token:RegisterEffect(e3,true)
			local e4=e2:Clone()
			e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e4:SetValue(1)
			token:RegisterEffect(e4,true)
		end
		Duel.SpecialSummonComplete()
		if Duel.IsExistingMatchingCard(c16200005.thfilter,tp,LOCATION_DECK,0,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c16200005.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end 
	end
end
function c16200005.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
