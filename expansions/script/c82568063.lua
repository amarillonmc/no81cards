--AK-偏锋的龙舌兰
function c82568063.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,1,3)
	c:EnableReviveLimit()
	 --Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,82568063)
	e1:SetCondition(c82568063.descost)
	e1:SetTarget(c82568063.target)
	e1:SetOperation(c82568063.operation)
	c:RegisterEffect(e1)
	--atklimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,82568163)
	e3:SetCondition(c82568063.spcon)
	e3:SetTarget(c82568063.sptg)
	e3:SetOperation(c82568063.spop)
	c:RegisterEffect(e3)
end
function c82568063.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x825) and (c:IsLevelAbove(7) or c:IsRankAbove(4))
			and (c:GetSummonLocation()==LOCATION_EXTRA or c:GetSummonType()==SUMMON_TYPE_RITUAL) and not c:IsType(TYPE_FUSION)
end
function c82568063.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c82568063.cfilter,1,nil,tp)
end
function c82568063.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c82568063.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
function c82568063.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
end
function c82568063.desfilter(c,atk,e)
	return c:IsFaceup() and c:IsAttackBelow(atk) 
end
function c82568063.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	if chk==0 then return Duel.IsExistingMatchingCard(c82568063.desfilter,tp,0,LOCATION_MZONE,1,nil,atk,e) end
	local g=Duel.GetMatchingGroup(c82568063.desfilter,tp,0,LOCATION_MZONE,nil,atk,e)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c82568063.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c82568063.desfilter,tp,0,LOCATION_MZONE,nil,atk,e)
	Duel.Destroy(g,REASON_EFFECT)
 
end