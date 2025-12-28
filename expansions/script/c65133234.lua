--幻叙咏者 小月
local s,id,o=GetID()
function s.initial_effect(c)
	--Link Summon
	aux.AddLinkProcedure(c,nil,2,3)
	c:EnableReviveLimit()
	--Place in S/T
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.placecon)
	e1:SetOperation(s.placeop)
	c:RegisterEffect(e1)	
end
function s.placecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function s.placeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,1))
		e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetRange(LOCATION_SZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetCountLimit(1)
		e2:SetTarget(s.sptg)
		e2:SetOperation(s.spop)
		c:RegisterEffect(e2)
		--Check Materials
		local mg=c:GetMaterial()
		if c:IsSummonType(SUMMON_TYPE_LINK) and mg:FilterCount(Card.IsSetCard,nil,0x838)>=2 then
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(aux.Stringid(id,2))
			e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
			e3:SetType(EFFECT_TYPE_IGNITION)
			e3:SetRange(LOCATION_SZONE)
			e3:SetCountLimit(1)
			e3:SetTarget(s.granttg)
			e3:SetOperation(s.grantop)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
			e4:SetRange(LOCATION_SZONE)
			e4:SetTargetRange(LOCATION_SZONE,0)
			e4:SetTarget(s.eftg)
			e4:SetLabelObject(e3)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e4)
		end
	end
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x838) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,3,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if #g<3 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:Select(tp,3,3,nil)
	Duel.ConfirmCards(1-tp,sg)
	local tc=sg:RandomSelect(1-tp,1):GetFirst()
	if tc then
		Duel.ConfirmCards(tp,tc)
		local b1=tc:IsAbleToHand()
		local b2=tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		local op=aux.SelectFromOptions(tp,
			{b1,1190},
			{b2,1152})
		local res=false
		if op==1 then
			res=Duel.SendtoHand(tc,nil,REASON_EFFECT)>0
			Duel.ConfirmCards(1-tp,tc)
		else
			res=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0
		end
		if res then
			Duel.SetLP(tp,Duel.GetLP(tp)-tc:GetAttack())
		end
	end
end
--Neighbor Grant Logic
function s.eftg(e,c)
	local seq=e:GetHandler():GetSequence()
	local cseq=c:GetSequence()
	return math.abs(seq-cseq)==1 and c:IsFaceup() and (c:GetType()&TYPE_CONTINUOUS>0 or c:GetType()&TYPE_TRAP>0)
end

function s.thfilter(c)
	return c:IsSetCard(0x838) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.granttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.grantop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,tc)
			local val=tc:GetAttack()+tc:GetDefense()
			Duel.SetLP(tp,Duel.GetLP(tp)-val)
		end
	end
end
