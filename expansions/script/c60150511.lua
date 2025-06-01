--最终的幻想
function c60150511.initial_effect(c)
	c:SetUniqueOnField(1,1,60150511)
	--xyz summon
	aux.AddXyzProcedure(c,c60150511.mfilter,11,11)
	c:EnableReviveLimit()
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60150511,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetCountLimit(1,60150511)
	e1:SetCondition(c60150511.sumcon)
	e1:SetTarget(c60150511.sumtg)
	e1:SetOperation(c60150511.sumop)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetValue(1)
	e2:SetCondition(c60150511.actcon)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLED)
	e3:SetOperation(c60150511.e3op)
	c:RegisterEffect(e3)
end
function c60150511.mfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c60150511.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c60150511.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c60150511.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c60150511.filter(c,e,tp)
	return c:GetRank()>=10 and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FIEND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsFaceup()
end
function c60150511.sumtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c60150511.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c60150511.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c60150511.filter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c60150511.e3op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttackTarget()
	if d==c then d=Duel.GetAttacker() end
	if not d or c:IsStatus(STATUS_BATTLE_DESTROYED) or not d:IsStatus(STATUS_BATTLE_DESTROYED) then return end
		
	Duel.Hint(HINT_CARD,0,60150511)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60150511,1))
		
	local ac=d:GetCode()
	e:GetHandler():SetHint(CHINT_CARD,ac)
	--forbidden
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_FORBIDDEN)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(c60150511.bantg)
	e1:SetLabel(ac)
	Duel.RegisterEffect(e1,tp)
		
	if e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,60150510) then
		local a=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		if a==0 then return end
		local seq=d:GetSequence()
		if d:IsControler(1-tp) then seq=seq+16 end
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_DISABLE_FIELD)
		e2:SetLabel(seq)
		e2:SetOperation(c60150511.disop2)
		Duel.RegisterEffect(e2,tp)
	end
end
function c60150511.bantg(e,c)
	local fcode=e:GetLabel()
	return c:IsOriginalCodeRule(fcode)
end
function c60150511.disop2(e,tp)
	return bit.lshift(0x1,e:GetLabel())
end