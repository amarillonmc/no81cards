--闪耀的迷光 芹泽朝日
function c28315347.initial_effect(c)
	aux.AddCodeList(c,28335405)
	--Straylight spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28315347,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,28315347)
	e1:SetCondition(c28315347.slcon)
	e1:SetTarget(c28315347.sptg)
	e1:SetOperation(c28315347.spop)
	c:RegisterEffect(e1)
	--ash spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28315347,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,28315347)
	e2:SetCondition(c28315347.spcon)
	e2:SetTarget(c28315347.sptg)
	e2:SetOperation(c28315347.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--Straylight search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(28315347,1))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,38315347)
	e4:SetCost(c28315347.thcost)
	e4:SetTarget(c28315347.thtg)
	e4:SetOperation(c28315347.thop)
	c:RegisterEffect(e4)
	--position
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(28315347,2))
	e5:SetCategory(CATEGORY_POSITION+CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(2)
	e5:SetTarget(c28315347.potg)
	e5:SetOperation(c28315347.poop)
	c:RegisterEffect(e5)
end
function c28315347.ctfilter(c)
	return c:IsFaceup() and c:GetCounter(0x1283)>0
end
function c28315347.slcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c28315347.ctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c28315347.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x283)
end
function c28315347.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c28315347.cfilter,1,nil,tp)
end
function c28315347.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c28315347.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		Duel.BreakEffect()
		c:AddCounter(0x1283,1)
	end
end
function c28315347.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1283,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1283,3,REASON_COST)
end
function c28315347.thfilter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c28315347.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28315347.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28315347.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c28315347.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c28315347.pofilter(c)
	return c:IsFacedown() and c:IsCanChangePosition()
end
function c28315347.potg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28315347.pofilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and e:GetHandler():IsCanAddCounter(0x1283,1) and e:GetHandler():GetFlagEffect(28315347)==0 end
	e:GetHandler():RegisterFlagEffect(28315347,RESET_CHAIN,0,1)
	local g=Duel.GetMatchingGroup(c28315347.pofilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c28315347.chkfilter(c)
	return c:IsCode(28335405) and not c:IsPublic()
end
function c28315347.poop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c28315347.pofilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if Duel.ChangePosition(g,POS_FACEUP_DEFENSE)==1 and c:IsRelateToEffect(e) and c:IsFaceup() then
		c:AddCounter(0x1283,1)
		if Duel.IsExistingMatchingCard(c28315347.chkfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28315347,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local cg=Duel.SelectMatchingCard(tp,c28315347.chkfilter,tp,LOCATION_HAND,0,1,1,nil)
			Duel.ConfirmCards(1-tp,cg)
			Duel.ShuffleHand(tp)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
		end
	end
end
