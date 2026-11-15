--指挥乐士 荆棘
function c19209697.initial_effect(c)
	--CoMETIK search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,19209697)
	e1:SetCost(c19209697.thcost)
	e1:SetTarget(c19209697.thtg)
	e1:SetOperation(c19209697.thop)
	c:RegisterEffect(e1)
	--ash spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19209697,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,19209697+1)
	e2:SetCondition(c19209697.spcon)
	e2:SetTarget(c19209697.sptg)
	e2:SetOperation(c19209697.spop)
	c:RegisterEffect(e2)
	--activate cost
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_ACTIVATE_COST)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetRange(LOCATION_GRAVE)
	e0:SetTargetRange(0,1)
	e0:SetTarget(c19209697.chktg)
	e0:SetOperation(c19209697.chkop)
	e0:SetLabelObject(e2)
	c:RegisterEffect(e0)
end
function c19209697.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c19209697.thfilter(c,check)
	return c:IsAbleToHand() and (c:IsSetCard(0xb53) and c:IsType(TYPE_MONSTER) and not c:IsCode(19209697) or check and c:IsSetCard(0xb53) and c:IsType(TYPE_SPELL))
end
function c19209697.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	local check=not fc or not fc:IsCode(19209696) or fc:IsFacedown()
	if chk==0 then return Duel.IsExistingMatchingCard(c19209697.thfilter,tp,LOCATION_DECK,0,1,nil,check) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c19209697.thop(e,tp,eg,ep,ev,re,r,rp)
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	local check=not fc or not fc:IsCode(19209696) or fc:IsFacedown()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c19209697.thfilter,tp,LOCATION_DECK,0,1,1,nil,check)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c19209697.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetLabel()==1
end
function c19209697.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c19209697.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
		if tc then
			Duel.HintSelection(Group.FromCards(tc))
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetValue(500)
			e1:SetRange(LOCATION_MZONE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end
function c19209697.chktg(e,te,tp)
	local tc=te:GetHandler()
	if tc:IsAttackAbove(tc:GetBaseAttack()+1) then e:SetLabel(1) else e:SetLabel(0) end
	return true
end
function c19209697.chkop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(e:GetLabel())
end
