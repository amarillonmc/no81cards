--觅迹人混乱探索
function c9911521.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9911521)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9911521.target)
	e1:SetOperation(c9911521.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911521,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c9911521.handcon)
	c:RegisterEffect(e2)
	--discard deck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9911522)
	e3:SetTarget(c9911521.distg)
	e3:SetOperation(c9911521.disop)
	c:RegisterEffect(e3)
end
function c9911521.rmfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c9911521.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c9911521.rmfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c9911521.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c9911521.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c9911521.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() then
		if (tc:IsLocation(LOCATION_MZONE) or bit.band(tc:GetType(),TYPE_CONTINUOUS+TYPE_SPELL)==TYPE_CONTINUOUS+TYPE_SPELL)
			and tc:IsOriginalSetCard(0x5952) then
			if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 and not tc:IsReason(REASON_REDIRECT) then
				Duel.BreakEffect()
				if Duel.ReturnToField(tc) then
					if tc:GetOriginalType()&TYPE_MONSTER~=0 and tc:IsLocation(LOCATION_SZONE) then
						Duel.SendtoGrave(tc,REASON_RULE)
					end
					Duel.Draw(tp,1,REASON_EFFECT)
				end
			end
		else
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c9911521.handcon(e)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,0x5952)
end
function c9911521.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) and Duel.IsPlayerCanDiscardDeck(1-tp,3) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,PLAYER_ALL,3)
end
function c9911521.disop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetDecktopGroup(tp,3)
	local g2=Duel.GetDecktopGroup(1-tp,3)
	g1:Merge(g2)
	Duel.DisableShuffleCheck()
	if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 and g1:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9911521,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if #sg>0 then
			Duel.HintSelection(sg)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
