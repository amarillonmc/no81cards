--「」下级一号
function c44401001.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c44401001.rmtg)
	e1:SetOperation(c44401001.rmop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--run!
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_RECOVER)
	e0:SetType(EFFECT_TYPE_QUICK_F)
	e0:SetCode(EVENT_BECOME_TARGET)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c44401001.runcon)
	e0:SetCost(c44401001.run)
	e0:SetTarget(c44401001.runtg)
	e0:SetOperation(c44401001.runop)
	c:RegisterEffect(e0)
end
function c44401001.rmfilter(c)
	return c:IsSetCard(0xa4a) and c:IsAbleToRemove()
end
function c44401001.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44401001.rmfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c44401001.thfilter(c)
	return c:IsSetCard(0xa4a) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup() and c:IsAbleToHand()
end
function c44401001.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,c44401001.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #rg>0 then
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSummonType(SUMMON_TYPE_NORMAL)
		and Duel.IsExistingMatchingCard(c44401001.thfilter,tp,LOCATION_REMOVED,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(44401001,0)) then
		--to hand
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c44401001.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c44401001.runcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c44401001.run(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_CHAIN_END)
		e0:SetReset(RESET_PHASE+PHASE_END)
		e0:SetLabelObject(c)
		e0:SetCountLimit(1)
		e0:SetOperation(c44401001.retop)
		Duel.RegisterEffect(e0,tp)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(44401001,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(44401001)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		c:RegisterEffect(e1)
	end
end
function c44401001.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c44401001.runtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,300)
end
function c44401001.runop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,300,REASON_EFFECT)
end
