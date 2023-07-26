--方舟骑士-梅
c29051189.named_with_Arknight=1
function c29051189.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29051189,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,29051190)
	e1:SetCondition(c29051189.spcon)
	e1:SetTarget(c29051189.sptg)
	e1:SetOperation(c29051189.spop)
	c:RegisterEffect(e1)
	--announce
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29051189,2))
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,29051189)
	e3:SetTarget(c29051189.actg)
	e3:SetOperation(c29051189.acop)
	c:RegisterEffect(e3)
end
function c29051189.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER)
end
function c29051189.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c29051189.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c29051189.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29051189.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c29051189.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5) and Duel.GetDecktopGroup(tp,5):FilterCount(Card.IsAbleToGrave,nil)>0 end
	local g=Duel.GetDecktopGroup(tp,5)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c29051189.filter(c,code)
	return c:IsCode(code)
end
function c29051189.thfilter(c)
	return c:IsAbleToHand()
end
function c29051189.tgfilter(c)
	return c:IsAbleToGrave()
end
function c29051189.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if Duel.IsPlayerCanDiscardDeck(tp,5) then
		Duel.ConfirmDecktop(tp,5)
		local g=Duel.GetDecktopGroup(tp,5)
		if g:GetCount()>0 then
			if g:IsExists(c29051189.filter,1,nil,ac) and g:IsExists(c29051189.thfilter,1,nil) then
				if Duel.SelectYesNo(tp,aux.Stringid(29051189,1)) then
					Duel.DisableShuffleCheck()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local sg=g:FilterSelect(tp,c29051189.thfilter,1,1,nil)
					Duel.SendtoHand(sg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,sg)
					Duel.ShuffleHand(tp)
				end
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sg=g:FilterSelect(tp,c29051189.tgfilter,1,1,nil)
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
			
		end
	end
end



