--方舟骑士团-幽灵鲨
c29072102.named_with_Arknight=1
function c29072102.initial_effect(c)
	--to hand/set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29072102,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c29072102.cost)
	e1:SetTarget(c29072102.thtg)
	e1:SetOperation(c29072102.thop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--sp
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29072102,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,29072102)
	e3:SetCost(c29072102.cost)
	e3:SetCondition(c29072102.con)
	e3:SetTarget(c29072102.sptg)
	e3:SetOperation(c29072102.spop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(29072102,ACTIVITY_CHAIN,c29072102.chainfilter)
end
--cost
function c29072102.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	return (rc:IsSetCard(0x87af) and rc:IsAttribute(ATTRIBUTE_WATER)) or not re:IsActiveType(TYPE_MONSTER) or not rc:IsAttribute(ATTRIBUTE_WATER)
end
function c29072102.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(29072102,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c29072102.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c29072102.aclimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0x87af) and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttribute(ATTRIBUTE_WATER)
end
--e2
function c29072102.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated() and re:IsActiveType(TYPE_MONSTER) and re:GetOwner():IsAttribute(ATTRIBUTE_WATER)
end
function c29072102.con(e,tp,eg,ep,ev,re,r,rp)
	local attr=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_ATTRIBUTE)
	return re:GetHandler()~=e:GetHandler() and re:IsActiveType(TYPE_MONSTER) and attr&ATTRIBUTE_WATER>0
end
--e1e2
function c29072102.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c29072102.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			if Duel.SelectYesNo(tp,aux.Stringid(29072102,2)) then
				Duel.NegateEffect(ev)
			end
		end
	end
end
--e3e4
function c29072102.thfilter(c)
	if not (c:IsSetCard(0x67af) and c:IsType(TYPE_SPELL+TYPE_TRAP)) then return false end
	return c:IsAbleToHand() or c:IsSSetable()
end
function c29072102.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29072102.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c29072102.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c29072102.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc)
		end
	end
end












