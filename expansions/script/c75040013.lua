--器者百式-缠龙破势
function c75040013.initial_effect(c)
	aux.AddCodeList(c,75040001)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(75040013,2))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c75040013.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c75040013.target)
	e1:SetOperation(c75040013.activate)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c75040013.tkcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c75040013.tktg)
	e2:SetOperation(c75040013.tkop)
	c:RegisterEffect(e2)
end
function c75040013.hcfilter(c)
	return c:IsCode(75040001) and c:IsFaceup()
end
function c75040013.handcon(e)
	return Duel.IsExistingMatchingCard(c75040013.hcfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil) or Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0
end
function c75040013.cfilter(c,e,tp)
	return c:IsCode(75040001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp) or Duel.IsExistingMatchingCard(c75040013.hcfilter,tp,LOCATION_ONFIELD,0,1,nil) and c:IsType(TYPE_EQUIP) and Duel.IsExistingTarget(c75040013.tcfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil,c) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function c75040013.tcfilter(tc,ec)
	return tc:IsFaceup() and ec:CheckEquipTarget(tc)
end
function c75040013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75040013.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
end
function c75040013.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_M1)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetTargetRange(1,0)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()>=PHASE_MAIN1 then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(c75040013.skipcon)
			e1:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e1,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,c75040013.cfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	if tc:IsCode(75040001) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local ec=Duel.SelectMatchingCard(tp,c75040013.tcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tc):GetFirst()
		Duel.HintSelection(Group.FromCards(ec))
		Duel.Equip(tp,tc,ec)
	end
end
function c75040013.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c75040013.chkfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and (c:GetPreviousRaceOnField()&RACE_WYRM)>0
end
function c75040013.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75040013.chkfilter,1,nil,tp)
end
function c75040013.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,75040022,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_WYRM,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c75040013.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,75040022,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_WYRM,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,75040022)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
