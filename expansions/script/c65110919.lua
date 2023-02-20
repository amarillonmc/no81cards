--坎特伯雷的最后防线
function c65110919.initial_effect(c)
	aux.AddCodeList(c,65110002)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,65110919)
	e1:SetCondition(c65110919.con)
	e1:SetTarget(c65110919.target)
	e1:SetOperation(c65110919.activate)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65110919,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,65110920)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65110919.eqtg)
	e2:SetOperation(c65110919.eqop)
	c:RegisterEffect(e2)
	if not c65110919.global_check then
		c65110919.global_check=true
		local ge1=Effect.GlobalEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetCondition(c65110919.checkcon)
		ge1:SetOperation(c65110919.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c65110919.spcfilter(c,tp)
	return c:GetReasonPlayer()==1-tp  and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsType(TYPE_MONSTER)
end
function c65110919.checkcon(e,tp,eg,ep,ev,re,r,rp)
	local v=0
	if eg:IsExists(c65110919.spcfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(c65110919.spcfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function c65110919.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsType,nil,TYPE_MONSTER)
	local tc=g:GetFirst()
	while tc do
		if Duel.GetFlagEffect(tc:GetControler(),65110919)==0 then
			Duel.RegisterFlagEffect(tc:GetControler(),65110919,RESET_PHASE+PHASE_END,0,1)		   
		end
		if Duel.GetFlagEffect(0,65110919)>0 and Duel.GetFlagEffect(1,65110919)>0 then
			break
		end
		tc=g:GetNext()
	end
end
function c65110919.con(e,tp,eg,ep,ev,re,r,rp)
	--Debug.Message(Duel.GetFlagEffect(tp,65110919))
	return Duel.GetFlagEffect(tp,65110919)>0
end
function c65110919.spfilter(c,e,tp)
	return c:IsCode(65110917) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c65110919.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,65110002) and Duel.IsExistingMatchingCard(c65110919.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsCode,tp,LOCATION_MZONE,0,1,1,nil,65110002)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c65110919.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local th=Duel.GetFirstMatchingCard(c65110919.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if th then
		Duel.BreakEffect()
		Duel.SpecialSummon(th,0,tp,tp,true,false,POS_FACEUP)
		th:CompleteProcedure()
	end
end
function c65110919.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,65110917) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,65110921) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
	end
end
function c65110919.eqop(e,tp,eg,ep,ev,re,r,rp)
	local equip=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,65110917)
	local tc=Duel.GetFirstMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,65110921)
	if tc then
		if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)>0 and equip and not tc:IsForbidden() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local sc=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_MZONE,0,1,1,nil,65110917)
			Duel.Equip(tp,tc,sc:GetFirst())
		end
	end
end