--幽灵骑士Specter·深渊魂
function c9980947.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c9980947.lcheck)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980947,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9980947.linkcon)
	e1:SetTarget(c9980947.target)
	e1:SetOperation(c9980947.operation)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c9980947.atkval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	--damage val
	local e5=e3:Clone()
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e5)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c9980947.sptg)
	e2:SetOperation(c9980947.spop)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980947.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980947.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980947,2))
end
function c9980947.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xcbc2)
end
function c9980947.linkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9980947.eqfilter(c,ec)
	return c:IsSetCard(0xcbc2) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_SYNCHRO) and not c:IsForbidden()
end
function c9980947.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9980947.eqfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c9980947.operation(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
   local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c9980947.eqfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,c)
		if g:GetCount()>0 then
			Duel.Equip(tp,g:GetFirst(),c)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c9980947.eqlimit)
			e1:SetLabelObject(c)
			g:GetFirst():RegisterEffect(e1)
		end
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980947,3))
end
function c9980947.eqlimit(e,c)
	return e:GetOwner()==c
end
function c9980947.atkval(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_REMOVED,0,nil,TYPE_MONSTER)*300
end
function c9980947.tgfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xcbc2) and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c9980947.spfilter(c,e,tp)
	return c:IsLevel(7) and c:IsSetCard(0xcbc2) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9980947.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980947.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.IsExistingMatchingCard(c9980947.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9980947.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,c9980947.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local tc=tg:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9980947.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
