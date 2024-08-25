--麻薯
local s,id,o=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,1,id)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--summon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetCondition(s.condition)
	c:RegisterEffect(e2)
	--summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10000080,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,id)
	e4:SetCondition(s.hsumcon)
	e4:SetOperation(s.hsumop)
	c:RegisterEffect(e4)
	--Special Summon (deck)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(1064)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(s.spcon2)
	e3:SetTarget(s.sptg2)
	e3:SetOperation(s.spop2)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCondition(s.lfcon)
	e5:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e5)
	--pos
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(1110)
	e7:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCondition(s.thcon)
	e7:SetTarget(s.thtg)
	e7:SetOperation(s.thop)
	c:RegisterEffect(e7)
	if not s.global_flag then
		s.global_flag=true
		--Negate
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetCondition(s.condition)
		ge1:SetOperation(s.operation)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:GetActivateLocation()==LOCATION_REMOVED and re:IsActiveType(TYPE_MONSTER)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:GetActivateLocation()==LOCATION_REMOVED and re:IsActiveType(TYPE_MONSTER) then
		rc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
	end
end
function s.cthfilter(c)
	return c:IsAbleToHand() and c:GetFlagEffect(id)==0 and c:IsRace(RACE_ZOMBIE)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(82800114)~=0
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cthfilter,tp,LOCATION_REMOVED+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED+LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.cthfilter,tp,LOCATION_REMOVED+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.lfcon(e)
	return e:GetHandler():IsFaceup()
end
function s.condition(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),id)==0
end
function s.hsumcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end 
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,82800147,RESET_PHASE+PHASE_END,0,1)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10000080,1))
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e4:SetTargetRange(POS_FACEUP_DEFENSE,1)
	e4:SetCondition(s.ttcon)
	e4:SetOperation(s.ttop)
	e4:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e4)
	local res=c:IsSummonable(false,nil) and Duel.GetCurrentChain()==0
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
	Duel.ResetFlagEffect(tp,82800147)
	e4:Reset()
	return res
end
function s.ttcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	return minc<=1 and Duel.CheckTribute(c,1,1,mg,1-tp)
end
function s.hsumop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if Duel.RegisterFlagEffect(tp,82800147,RESET_PHASE+PHASE_END,0,1) then
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(10000080,1))
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_LIMIT_SUMMON_PROC)
		e4:SetTargetRange(POS_FACEUP_DEFENSE,1)
		e4:SetCondition(s.ttcon)
		e4:SetOperation(s.ttop)
		e4:SetValue(SUMMON_TYPE_ADVANCE)
		c:RegisterEffect(e4)
	end
	Duel.Summon(tp,c,false,nil)
end
function s.ttop(e,tp,eg,ep,ev,re,r,rp,c)
		local mg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
		local g=Duel.SelectTribute(tp,c,1,1,mg,1-tp)
		c:SetMaterial(g)
		Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
		--summon success
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_SUMMON_SUCCESS)
		e3:SetOperation(s.sumop)
	e3:SetCountLimit(1)
	e3:SetLabel(tp)
	c:RegisterEffect(e3,true)
	e:Reset()
end
function s.sumfilter(c)
	return c:IsSummonable(true,nil)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=e:GetLabel()
	Duel.ResetFlagEffect(tp,82800147)
	if c and Duel.IsExistingMatchingCard(s.sumfilter,p,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
		and Duel.SelectYesNo(p,1) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SelectMatchingCard(p,s.sumfilter,p,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		Duel.Summon(p,g:GetFirst(),true,nil)
	end
	e:Reset()
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,82800150)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 
			and Duel.IsPlayerCanSpecialSummonMonster(tp,82800150,0,TYPES_TOKEN_MONSTER,0,0,5,RACE_ZOMBIE,ATTRIBUTE_WIND,POS_FACEUP_DEFENSE) 
				and Duel.IsPlayerCanSpecialSummonMonster(1-tp,82800150,0,TYPES_TOKEN_MONSTER,0,0,5,RACE_ZOMBIE,ATTRIBUTE_WIND,POS_FACEUP_DEFENSE)  end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,82800150,0,TYPES_TOKEN_MONSTER,0,0,5,RACE_ZOMBIE,ATTRIBUTE_WIND,POS_FACEUP_DEFENSE)
			and Duel.IsPlayerCanSpecialSummonMonster(1-tp,82800150,0,TYPES_TOKEN_MONSTER,0,0,5,RACE_ZOMBIE,ATTRIBUTE_WIND,POS_FACEUP_DEFENSE) then
		for i=0,1 do
			local token=Duel.CreateToken(tp,82800150)
			Duel.SpecialSummonStep(token,0,i,i,false,false,POS_FACEUP_DEFENSE)
			--cannot release
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e4:SetRange(LOCATION_MZONE)
			e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			e4:SetValue(1)
			token:RegisterEffect(e4)
		end
		Duel.SpecialSummonComplete()
	end
end