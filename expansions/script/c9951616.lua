--骑士王·耀于至远之枪
function c9951616.initial_effect(c)
	 --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951616,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,9951616)
	e1:SetCondition(c9951616.condition)
	e1:SetTarget(c9951616.target)
	e1:SetOperation(c9951616.operation)
	c:RegisterEffect(e1)
  --to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951616,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9951616)
	e2:SetCost(c9951616.thcost)
	e2:SetTarget(c9951616.thtg)
	e2:SetOperation(c9951616.thop)
	c:RegisterEffect(e2)
  --attack
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetOperation(c9951616.atkop)
	c:RegisterEffect(e4)
 --cannot spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c9951616.regop)
	c:RegisterEffect(e2)
	 --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951616.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951616.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951616,0))
Duel.Hint(HINT_SOUND,0,aux.Stringid(9951616,1))
end
function c9951616.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xba5) and c:IsLevelAbove(5)
		and Duel.IsExistingMatchingCard(c9951616.cfilter2,tp,LOCATION_MZONE,0,1,nil,c:GetCode())
end
function c9951616.cfilter2(c,code)
	return c:IsFaceup() and c:IsSetCard(0xba5) and c:IsLevelAbove(5) and not c:IsCode(code)
end
function c9951616.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9951616.cfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c9951616.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9951616.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
function c9951616.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lp=Duel.GetLP(1-tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
	e1:SetValue(lp)
	c:RegisterEffect(e1)
end
function c9951616.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(0,1)
	e1:SetTarget(c9951616.splimit)
	e1:SetLabelObject(e)
	Duel.RegisterEffect(e1,tp)
end
function c9951616.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLevelAbove(5)
end
function c9951616.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,Card.IsSetCard,1,c,0xba5) end
	local g=Duel.SelectReleaseGroupEx(tp,Card.IsSetCard,1,1,c,0xba5)
	e:SetLabel(g:GetFirst():GetType())
	Duel.Release(g,REASON_COST)
end
function c9951616.thfilter1(c)
	return c:IsLevelAbove(5) and c:IsSetCard(0xba5) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9951616.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9951616.thfilter1,tp,LOCATION_DECK,0,1,nil)
		and not c:IsLevel(4) and c:IsLevelAbove(1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9951616.thfilter2(c)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c9951616.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c9951616.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 and Duel.SendtoHand(g1,nil,REASON_EFFECT)~=0 and g1:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g1)
		local c=e:GetHandler()
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(8)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			local g2=Duel.GetMatchingGroup(c9951616.thfilter2,tp,LOCATION_DECK,0,nil)
			if bit.band(e:GetLabel(),TYPE_LINK)~=0 and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9951616,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g2:Select(tp,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		end
	end
end
