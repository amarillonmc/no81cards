--「」下级四号
function c44401004.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c44401004.tdtg)
	e1:SetOperation(c44401004.tdop)
	c:RegisterEffect(e1)
	--run!
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_REMOVE)
	e0:SetType(EFFECT_TYPE_QUICK_F)
	e0:SetCode(EVENT_BECOME_TARGET)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c44401004.runcon)
	e0:SetCost(c44401004.run)
	e0:SetTarget(c44401004.runtg)
	e0:SetOperation(c44401004.runop)
	c:RegisterEffect(e0)
end
function c44401004.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local check=c:IsSummonType(SUMMON_TYPE_NORMAL) and c:GetFlagEffect(44401004)==0
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_REMOVED)
end
function c44401004.thfilter(c)
	return c:IsSetCard(0xa4a) and c:IsAbleToHand() and c:IsFaceupEx()
end
function c44401004.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local check=c:IsRelateToEffect(e) and c:IsSummonType(SUMMON_TYPE_NORMAL) and c:GetFlagEffect(44401004)==0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	if g:GetCount()~=1 then return end
	if Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_EFFECT)~=0 and check
		and Duel.IsExistingMatchingCard(c44401004.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(44401004,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c44401004.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
		if #tg>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
		c:RegisterFlagEffect(44401004,RESET_EVENT+RESETS_WITHOUT_TEMP_REMOVE+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(44401004,0))
	end
end
function c44401004.runcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c44401004.run(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_CHAIN_END)
		e0:SetReset(RESET_PHASE+PHASE_END)
		e0:SetLabelObject(c)
		e0:SetCountLimit(1)
		e0:SetOperation(c44401004.retop)
		Duel.RegisterEffect(e0,tp)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(44401004,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(44401001)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		c:RegisterEffect(e1)
	end
end
function c44401004.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c44401004.runtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,PLAYER_ALL,LOCATION_DECK)
end
function c44401004.runop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 or Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
	local g1=Duel.GetDecktopGroup(tp,1)
	local g2=Duel.GetDecktopGroup(1-tp,1)
	g1:Merge(g2)
	Duel.DisableShuffleCheck()
	Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
end
