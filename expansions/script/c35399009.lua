--骇骨龙 阴骇幽灵
function c35399009.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35399009,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,35399009)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c35399009.con1)
	e1:SetTarget(c35399009.tg1)
	e1:SetOperation(c35399009.op1)
	c:RegisterEffect(e1)	
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35399009,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,35399010)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c35399009.tg2)
	e2:SetOperation(c35399009.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c35399009.val3)
	c:RegisterEffect(e3)
--
end
--
function c35399009.con1(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return rp~=tp and (loc&(LOCATION_HAND+LOCATION_GRAVE))~=0
end
function c35399009.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c35399009.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetMZoneCount(tp)<1 then return end
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1_1:SetRange(LOCATION_MZONE)
		e1_1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1_1:SetValue(c35399009.efilter1_1)
		if Duel.GetTurnPlayer()==tp
			and Duel.GetCurrentPhase()==PHASE_END then
			e1_1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_SELF_TURN,2)
		else
			e1_1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_SELF_TURN)
		end
		c:RegisterEffect(e1_1)
	end
end
function c35399009.efilter1_1(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
--
function c35399009.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
function c35399009.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if sg:GetCount()>0 then Duel.Destroy(sg,REASON_EFFECT) end
end
--
function c35399009.val3(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end