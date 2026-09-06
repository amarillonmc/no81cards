--勘破数理罪论
function c88887003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88887003+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c88887003.target)
	e1:SetOperation(c88887003.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,18887003)
	e2:SetCondition(c88887003.secon)
	e2:SetTarget(c88887003.setg)
	e2:SetOperation(c88887003.seop)
	c:RegisterEffect(e2)
end
function c88887003.sefilter1(c)
	return c:IsCode(88887005) and c:IsSSetable()
end
function c88887003.sefilter2(c)
	return c:IsSetCard(0x881) and c:IsType(TYPE_MONSTER)
end
function c88887003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE-LOCATION_FZONE)>=2
		and Duel.IsExistingMatchingCard(c88887003.sefilter1,tp,LOCATION_DECK,0,1,nil) 
		and Duel.IsExistingMatchingCard(c88887003.sefilter2,tp,LOCATION_DECK,0,1,nil) 
	end
end
function c88887003.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE-LOCATION_FZONE)<2 then return end
	local g1=Duel.GetMatchingGroup(c88887003.sefilter1,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c88887003.sefilter2,tp,LOCATION_DECK,0,nil)
	if #g1>0 and #g2>0 then
		local sg=Group.CreateGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg1=g1:Select(tp,1,1,nil)
		sg:Merge(sg1)
		local sg2=g2:Select(tp,1,1,nil)
		sg:Merge(sg2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_MONSTER_SSET)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetReset(RESET_CHAIN)
		e1:SetValue(TYPE_SPELL)
		sg2:GetFirst():RegisterEffect(e1)
		Duel.SSet(tp,sg,tp,false)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleSetCard(sg)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
		local sg3=sg:Select(1-tp,1,1,nil)
		sg:Sub(sg3)
		Duel.Destroy(sg3,REASON_EFFECT)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c88887003.sefilter3(c)
	return c:IsSetCard(0x881) and c:IsSSetable() and not c:IsType(TYPE_FIELD+TYPE_MONSTER) and not c:IsCode(88887003)
end
function c88887003.sefilter4(c)
	return c:IsCode(88887003)
end
function c88887003.secon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c88887003.setg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c88887003.sefilter3(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>=2
		and e:GetHandler():IsSSetable()
		and Duel.IsExistingTarget(c88887003.sefilter3,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c88887003.sefilter3,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g+e:GetHandler(),2,0,0)
end
function c88887003.seop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<2 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
		local sg=Group.CreateGroup()
		sg:AddCard(tc)
		sg:AddCard(c)
		Duel.SSet(tp,sg,tp,false)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleSetCard(sg)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
		local sg3=sg:Select(1-tp,1,1,nil)
		sg:Sub(sg3)			
		if Duel.Destroy(sg3,REASON_EFFECT)~=0 and sg3:FilterCount(c88887003.sefilter4,nil)~=0 and Duel.IsPlayerCanDraw(1-tp,1) then
			Duel.Draw(1-tp,1,REASON_EFFECT)
		end
		Duel.ConfirmCards(1-tp,sg)
	end
end