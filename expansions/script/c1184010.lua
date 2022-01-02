--饮食艺术·和菓子
function c1184010.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1184010,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_ANNOUNCE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c1184010.cost1)
	e1:SetTarget(c1184010.tg1)
	e1:SetOperation(c1184010.op1)
	c:RegisterEffect(e1)
--
end
--
function c1184010.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c1184010.tfilter1_1(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsSetCard(0x3e12) and c:IsType(TYPE_MONSTER)
end
function c1184010.tfilter1_2(c)
	return c:IsSetCard(0x3e12) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c1184010.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c1184010.tfilter1_1,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return ct~=1 or Duel.IsExistingMatchingCard(c1184010.tfilter1_2,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c1184010.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c1184010.tfilter1_1,tp,LOCATION_GRAVE,0,nil)
	if ct==0 then
		local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,1)
		e2:SetLabel(ac)
		e2:SetValue(c1184010.aclimit2)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
	if ct==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c1184010.tfilter1_2,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
	if ct==2 then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetCode(EFFECT_ADD_ATTRIBUTE)
		e3:SetRange(LOCATION_GRAVE)
		e3:SetValue(ATTRIBUTE_WATER)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetDescription(aux.Stringid(1184010,1))
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e4:SetCountLimit(1)
		e4:SetLabel(Duel.GetTurnCount())
		e4:SetCondition(c1184010.con4)
		e4:SetOperation(c1184010.op4)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
			e4:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
		else
			e4:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		end
		Duel.RegisterEffect(e4,tp)
	end
end
function c1184010.aclimit2(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and re:GetHandler():IsCode(e:GetLabel())
end
function c1184010.cfilter4(c,e,tp)
	return c:IsSetCard(0x3e12) and c:IsAttribute(ATTRIBUTE_EARTH)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c1184010.con4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
		and Duel.GetTurnCount()~=e:GetLabel()
		and Duel.IsExistingMatchingCard(c1184010.cfilter4,tp,LOCATION_EXTRA,0,1,nil,e,tp)
end
function c1184010.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,1184010)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local mg=Duel.SelectMatchingCard(tp,c1184010.cfilter4,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if mg:GetCount()>0 then
		Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
	end
end
--