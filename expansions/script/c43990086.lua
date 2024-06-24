--终点的玫瑰告示牌
local m=43990086
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,c43990086.ffilter,5,99,true)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c43990086.spcon)
	e1:SetCost(c43990086.spcost)
	e1:SetTarget(c43990086.sptg)
	e1:SetOperation(c43990086.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c43990086.dscon)
	e2:SetOperation(c43990086.dsop)
	c:RegisterEffect(e2)
	
end
function c43990086.ffilter(c,fc)
	return c:IsRace(RACE_ILLUSION)
end
function c43990086.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,e:GetHandler(),1-tp) and eg:GetCount()==1
end
function c43990086.sp1filter(c)
	return c:IsRace(RACE_ILLUSION) and c:IsAbleToGraveAsCost()
end
function c43990086.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c43990086.sp1filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c43990086.sp1filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c43990086.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,43990088,0,TYPES_TOKEN_MONSTER,tc:GetAttack(),tc:GetDefense(),2,RACE_ILLUSION,ATTRIBUTE_EARTH,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c43990086.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local c=e:GetHandler()
	if tc then
			local atk=tc:GetAttack()
			local def=tc:GetDefense()
			if Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
				and Duel.IsPlayerCanSpecialSummonMonster(tp,43990088,0,TYPES_TOKEN_MONSTER,atk,def,2,RACE_ILLUSION,ATTRIBUTE_EARTH,POS_FACEUP,1-tp) then
				local token=Duel.CreateToken(tp,43990088)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK)
				e1:SetValue(atk)
				e1:SetReset(RESET_EVENT+RESET_TURN_SET)
				token:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_SET_DEFENSE)
				e2:SetValue(def)
				e2:SetReset(RESET_EVENT+RESET_TURN_SET)
				token:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
				e3:SetCode(EVENT_LEAVE_FIELD)
				e3:SetOperation(c43990086.damop)
				e3:SetValue(math.floor(atk/2))
				token:RegisterEffect(e3,true)
				Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP)
			end
	end
end
function c43990086.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Damage(c:GetPreviousControler(),e:GetValue(),REASON_EFFECT)
	e:Reset()
end



function c43990086.spfilter(c)
	return c:IsFaceup() and c:IsCode(43990088)
end
function c43990086.dscon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local tp=e:GetHandler():GetControler()
	local ct=Duel.GetMatchingGroupCount(c43990086.spfilter,tp,0,LOCATION_MZONE,nil)
	return ct>2 and not ((ph==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or ph==PHASE_DAMAGE_CAL) and (ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2)
end
function c43990086.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c43990086.spfilter,tp,0,LOCATION_MZONE,nil)
	if ct>2 then
		local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
