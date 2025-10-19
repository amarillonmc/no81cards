--化龙巫女 桔梗
function c95101213.initial_effect(c)
	--spsummon
	local se1=Effect.CreateEffect(c)
	se1:SetType(EFFECT_TYPE_FIELD)
	se1:SetCode(EFFECT_SPSUMMON_PROC)
	se1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	se1:SetRange(LOCATION_HAND)
	se1:SetCountLimit(1,95101213+EFFECT_COUNT_CODE_OATH)
	se1:SetCondition(c95101213.sprcon)
	se1:SetOperation(c95101213.sprop)
	c:RegisterEffect(se1)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,95101213)
	e1:SetCost(c95101213.eqcost)
	e1:SetTarget(c95101213.eqtg)
	e1:SetOperation(c95101213.eqop)
	c:RegisterEffect(e1)
end
function c95101213.sprfilter(c)
	return c:IsSetCard(0x5bb0) and c:IsAbleToGraveAsCost()
end
function c95101213.sprcon(e,c)
	if c==nil then return true end
	return Duel.GetMZoneCount(c:GetControler())>0
		and Duel.IsExistingMatchingCard(c95101213.sprfilter,c:GetControler(),LOCATION_EXTRA,0,1,nil)
end
function c95101213.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c95101213.sprfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_COUNT_CODE_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c95101213.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c95101213.splimit(e,c)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end
function c95101213.chkfilter(c)
	return c:IsSetCard(0x5bb0) and not c:IsPublic()
end
function c95101213.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95101213.chkfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c95101213.chkfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c95101213.eqfilter(c,tp)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) and not c:IsForbidden()
end
function c95101213.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c95101213.eqfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler(),tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
end
function c95101213.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 and c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,c95101213.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c95101213.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c95101213.eqlimit(e,c)
	return e:GetOwner()==c
end
