--究极白蛇神·神抚子
function c9950318.initial_effect(c)
	  --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_REPTILE),1,6)
	c:EnableReviveLimit()
--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--damage val
	local e5=e3:Clone()
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e5)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c9950318.efilter)
	c:RegisterEffect(e3)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950318,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c9950318.spcost)
	e2:SetTarget(c9950318.target)
	e2:SetOperation(c9950318.operation)
	c:RegisterEffect(e2)
  --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950318.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950318.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950318,0))
end
function c9950318.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c9950318.filter(c,e,sp)
	return c:IsAttackBelow(3000) and (c:IsAttribute(ATTRIBUTE_DARK) or c:IsRace(RACE_REPTILE)) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c9950318.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9950318.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9950318.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
end
function c9950318.gfilter(c,rank)
	return c:IsRank(rank)
end
function c9950318.operation(e,tp,eg,ep,ev,re,r,rp)
   local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(c9950318.filter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if ft<=0 or tg:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:Select(tp,ft,ft,nil)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do 
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(500)
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(9950318,2))
		e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_BATTLE_START)
		e1:SetCondition(c9950318.descon2)
		e1:SetTarget(c9950318.destg2)
		e1:SetOperation(c9950318.desop2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function c9950318.descon2(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d==e:GetHandler() then d=Duel.GetAttacker() end
	e:SetLabelObject(d)
	return d~=nil
end
function c9950318.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local d=e:GetLabelObject()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,d,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,d:GetBaseAttack())
end
function c9950318.desop2(e,tp,eg,ep,ev,re,r,rp)
	local d=e:GetLabelObject()
	local dam=d:GetBaseAttack()
	if d:IsRelateToBattle() and Duel.Destroy(d,REASON_EFFECT)~=0 and dam>0 then
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end