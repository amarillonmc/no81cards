--王棋升变—深蓝皇冠
function c82568069.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,82568069)
	e1:SetTarget(c82568069.linktg)
	e1:SetOperation(c82568069.linkop)
	c:RegisterEffect(e1)
end
function c82568069.tkfilter(c)
	return ((c:IsType(TYPE_LINK) and c:IsLinkAbove(2)) or c:IsCode(82567812)) and c:IsFaceup()
end
function c82568069.linktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsType(TYPE_LINK) or chkc:IsCode(82567812)) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c82568069.tkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c82568069.tkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c82568069.linkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not (tc:IsFaceup() and tc:IsRelateToEffect(e)) then return false end
	--link summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82568069,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c82568069.cost)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetTarget(c82568069.target)
	e1:SetOperation(c82568069.operation)
	tc:RegisterEffect(e1)
	tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(82568069,0))
	
end
function c82568069.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c82568069.filter(c,e,tp,mc)
	return c:IsLinkBelow(4) and c:IsType(TYPE_LINK) and c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_DARK)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c82568069.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c82568069.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c82568069.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c82568069.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
		local tc=g:GetFirst()
		if tc then
			if Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)~=0 then
			tc:CompleteProcedure()
			tc:AddCounter(0x5825,2)
			if not tc:IsSetCard(0x825) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			end
			end
		end
end