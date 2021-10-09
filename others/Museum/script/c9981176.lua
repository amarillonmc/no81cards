--骑士时刻·Zonjis
function c9981176.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xbca),3)
	c:EnableReviveLimit()
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(c9981176.indval)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c9981176.efilter)
	c:RegisterEffect(e3)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981176,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c9981176.eqtg)
	e2:SetOperation(c9981176.eqop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c9981176.atkval)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981176.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981176.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981176,0))
end
function c9981176.indval(e,c)
	return c:IsSetCard(0xbca)
end
function c9981176.efilter(e,te)
	return te:GetHandler():IsSetCard(0xbca)
end
function c9981176.eqfilter(c)
	return c:IsSetCard(0xbca) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c9981176.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9981176.eqfilter,tp,0,LOCATION_GRAVE+LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE+LOCATION_MZONE)
end
function c9981176.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9981176.eqfilter),tp,0,LOCATION_GRAVE+LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c,true) then return end
		tc:RegisterFlagEffect(9981176,RESET_EVENT+RESETS_STANDARD,0,0)
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c9981176.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c9981176.eqlimit(e,c)
	return e:GetOwner()==c
end
function c9981176.atkfilter(c)
	return c:IsSetCard(0xbca) and c:GetAttack()>=0 and c:GetFlagEffect(9981176)~=0
end
function c9981176.atkval(e,c)
	local g=e:GetHandler():GetEquipGroup():Filter(c9981176.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
