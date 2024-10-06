--Kano
function c37900103.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,37900103)
	e1:SetCondition(c37900103.con)
	e1:SetTarget(c37900103.tg)
	e1:SetOperation(c37900103.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c37900103.tg2)
	e2:SetOperation(c37900103.op2)
	c:RegisterEffect(e2)
end
function c37900103.q(c)
	return c:IsFaceup() and not c:IsCode(37900103) and c:IsSetCard(0x382)
end
function c37900103.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c37900103.q,tp,4,0,1,nil)
end
function c37900103.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,4)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end
function c37900103.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c37900103.w(c)
	return not c:IsPublic()
end
function c37900103.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c37900103.w,tp,0,LOCATION_HAND,nil)
	if chk==0 then return #g>0 end
end
function c37900103.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c37900103.w,tp,0,LOCATION_HAND,nil)
	if #g>0 then
	local sg=g:RandomSelect(tp,1)
	Duel.ConfirmCards(tp,sg)
	if not c:IsRelateToEffect(e) then return end
	local tc=sg:GetFirst()
	local code=tc:GetOriginalCode()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTargetRange(0,1)
	e1:SetRange(4)
	e1:SetLabel(code)
	e1:SetValue(c37900103.aclimit)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
		if tc:IsType(TYPE_MONSTER) and not tc:IsType(TYPE_NORMAL) then
		if not _G["c"..code] then return end
		local copy_by = _G["c"..code].initial_effect
		local hack_registereffect
		hack_registereffect = Card["RegisterEffect"]
		Card["RegisterEffect"] = 
			function(card,effect,...)
				if effect:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) then return end
				effect:SetCondition(aux.TRUE)
				effect:SetCost(aux.TRUE)
				effect:SetRange(4)
				effect:SetReset(RESET_EVENT+RESETS_STANDARD)
				hack_registereffect(card,effect)				
			end
		do copy_by(c) end
		Card["RegisterEffect"] = hack_registereffect
		end
	end
end
function c37900103.aclimit(e,re,tp)
	if e:GetLabel()==nil then return end
	return re:GetHandler():IsCode(e:GetLabel())
end