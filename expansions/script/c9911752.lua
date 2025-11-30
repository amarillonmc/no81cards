--荒野君王解脱
function c9911752.initial_effect(c)
	aux.AddCodeList(c,9911614)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911752,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,9911752)
	e2:SetTarget(c9911752.sctg)
	e2:SetOperation(c9911752.scop)
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9911752,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,9911752)
	e3:SetCost(c9911752.tkcost)
	e3:SetTarget(c9911752.tktg)
	e3:SetOperation(c9911752.tkop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9911752,3))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_MOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,9911753+EFFECT_COUNT_CODE_DUEL)
	e4:SetCondition(c9911752.thcon)
	e4:SetTarget(c9911752.thtg)
	e4:SetOperation(c9911752.thop)
	c:RegisterEffect(e4)
end
function c9911752.thfilter(c)
	return aux.IsCodeOrListed(c,9911614) and c:IsAbleToHand()
end
function c9911752.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911752.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9911752.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9911752.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9911752.costfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsLevelAbove(2) and Duel.GetMZoneCount(tp,c)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9911753,0,TYPES_TOKEN_MONSTER,2500,2500,c:GetLevel()//2,RACE_ZOMBIE,ATTRIBUTE_FIRE)
end
function c9911752.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911752.costfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c9911752.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp):GetFirst()
	e:SetLabel(tc:GetLevel()//2)
	if Duel.Remove(tc,0,REASON_COST+REASON_TEMPORARY)~=0 then
		if tc:IsType(TYPE_TOKEN) or tc:IsReason(REASON_REDIRECT) then return end
		tc:RegisterFlagEffect(9911752,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(9911752,2))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(c9911752.retcon)
		e1:SetOperation(c9911752.retop)
		e1:SetLabel(Duel.GetTurnCount())
		Duel.RegisterEffect(e1,tp)
	end
end
function c9911752.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(9911752)~=0
end
function c9911752.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c9911752.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c9911752.tkop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9911753,0,TYPES_TOKEN_MONSTER,2500,2500,lv,RACE_ZOMBIE,ATTRIBUTE_FIRE) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,9911753)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			e1:SetValue(lv)
			token:RegisterEffect(e1,true)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
end
function c9911752.cfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_REMOVED)
		and not c:IsReason(REASON_SPSUMMON)
end
function c9911752.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9911752.cfilter,1,nil,tp)
end
function c9911752.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c9911752.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
