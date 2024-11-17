--工坊武器·卡莉斯塔工作室
function c65820015.initial_effect(c)
	aux.AddCodeList(c,65820000,65820005)
	--特招
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65820015,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65820015+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65820015.target)
	e1:SetOperation(c65820015.activate)
	c:RegisterEffect(e1)
	--加伪全抗
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65820015,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,65820015+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c65820015.setcon)
	e2:SetTarget(c65820015.settg)
	e2:SetOperation(c65820015.setop)
	c:RegisterEffect(e2)
end



function c65820015.spfilter(c,e,tp)
	return c:IsCode(65820000,65820005) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and aux.NecroValleyFilter()
end
function c65820015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65820015.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED)
end
function c65820015.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65820015.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c65820015.filter(c,e,tp)
	return c:IsCode(65820000,65820005) and c:IsFaceup()
end
function c65820015.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c65820015.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c65820015.setfilter(c,rc)
	return c:IsFaceup()
end
function c65820015.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c65820015.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65820015.setfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c65820015.setfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c65820015.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetValue(c65820015.efilter)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetOwnerPlayer(tp)
		tc:RegisterEffect(e3)
	end
	tc:RegisterFlagEffect(65820015,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65820015,2))
end
function c65820015.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end