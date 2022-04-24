--证物所引导至的真相
function c33200506.initial_effect(c)
	aux.AddCodeList(c,33200500)
	aux.AddCodeList(c,33200501)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33200506+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c33200506.target)
	e1:SetOperation(c33200506.activate)
	c:RegisterEffect(e1)
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c33200506.con)
	e2:SetOperation(c33200506.regop)
	c:RegisterEffect(e2)
end

--e1
function c33200506.filter(c)
	return c:IsCode(33200501) and c:IsFaceup()
end
function c33200506.spfilter(c,e,tp,check)
	return (aux.IsCodeListed(c,33200501) or c:IsCode(33200501)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (check or c:IsCode(33200501))
end
function c33200506.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c33200506.activate(e,tp,eg,ep,ev,re,r,rp)
	local fc=1
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then fc=0 end
	local chk1=Duel.IsExistingMatchingCard(c33200506.filter,tp,LOCATION_MZONE,0,1,nil)
	if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) 
		and Duel.IsExistingMatchingCard(c33200506.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,chk1) 
		and Duel.SelectYesNo(tp,aux.Stringid(33200506,0)) then  
		local g1=nil
		if fc==0 then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			g1=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			g1=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c33200506.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,chk1)
		if g1:GetCount()>0 and g2:GetCount()>0 then
			Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

--e2
function c33200506.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	return tc:IsControler(tp) and tc:GetFlagEffect(33200500)>0 and e:GetHandler():GetFlagEffect(33200507)==0 and e:GetHandler():GetFlagEffect(33200508)<2
end
function c33200506.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,33200506,RESET_EVENT+RESET_CHAIN,0,1)
	e:GetHandler():RegisterFlagEffect(33200507,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
end