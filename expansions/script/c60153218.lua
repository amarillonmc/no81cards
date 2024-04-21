--器灵契·永恒灵魂
function c60153218.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c60153218.e1op)
	c:RegisterEffect(e1)
	--level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_LEVEL)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3b2a))
	e2:SetValue(-3)
	c:RegisterEffect(e2)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(60153218,1))
	e5:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c60153218.drtg)
	e5:SetOperation(c60153218.drop)
	c:RegisterEffect(e5)
end

function c60153218.e1opf(c)
	return c:IsType(TYPE_MONSTER)
end
function c60153218.e1opf2(c)
	return not c:IsType(TYPE_TOKEN)
end
function c60153218.e1opf3(c,e,sp)
	return c:IsSetCard(0x3b2a) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c60153218.e1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c60153218.e1opf,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(c60153218.e1opf2,tp,0,LOCATION_MZONE,nil)
	local cg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c60153218.e1opf3),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,nil,e,tp)
	if #cg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g2>#g1 
		and Duel.SelectYesNo(tp,aux.Stringid(60153218,0)) then
		local ct=#g2-#g1
		if ct>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=cg:Select(tp,ct,ct,nil)
			local tc=sg:GetFirst()
			while tc do
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
				e1:SetRange(LOCATION_MZONE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(1)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
				tc:RegisterEffect(e2)
				local e3=e1:Clone()
				e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
				e3:SetValue(c60153218.fuslimit)
				tc:RegisterEffect(e3)
				local e4=e1:Clone()
				e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
				tc:RegisterEffect(e4)
				local e9=Effect.CreateEffect(c)
				e9:SetType(EFFECT_TYPE_SINGLE)
				e9:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e9:SetReset(RESET_EVENT+RESETS_REDIRECT)
				e9:SetValue(LOCATION_REMOVED)
				tc:RegisterEffect(e9,true)
				tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60153218,2))
				tc=sg:GetNext()
			end
			
		end
	end
end
function c60153218.fuslimit(e,c,st)
	return st==SUMMON_TYPE_FUSION
end
function c60153218.dropf(c)
	return c:IsFaceup() and c:IsSetCard(0x3b2a) and c:IsAbleToDeck()
end
function c60153218.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60153218.dropf,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.GetMatchingGroup(c60153218.dropf,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c60153218.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c60153218.dropf,tp,LOCATION_REMOVED,0,1,3,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end