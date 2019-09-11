--幽灵骑士ZeroSpecter
function c9980955.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c9980955.lcheck)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980955,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9980955.linkcon)
	e1:SetTarget(c9980955.target)
	e1:SetOperation(c9980955.operation)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c9980955.atkval)
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
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980955.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980955.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980955,2))
end
function c9980955.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xcbc2)
end
function c9980955.linkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9980955.eqfilter(c,ec)
	return c:IsSetCard(0xcbc2) and c:IsType(TYPE_SYNCHRO) and not c:IsForbidden()
end
function c9980955.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9980955.eqfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c9980955.operation(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	 local tc=Duel.GetFirstTarget()
	 if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c9980955.eqfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,c)
		if g:GetCount()>0 then
			Duel.Equip(tp,g:GetFirst(),c)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c9980955.eqlimit)
			e1:SetLabelObject(c)
			g:GetFirst():RegisterEffect(e1)
		end
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980955,3))
end
function c9980955.eqlimit(e,c)
	return e:GetOwner()==c
end
function c9980955.atkval(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil,TYPE_MONSTER)*300
end