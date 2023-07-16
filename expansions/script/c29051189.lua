--方舟骑士-梅
c29051189.named_with_Arknight=1
function c29051189.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c29051189.spcon)
	c:RegisterEffect(e1)
	--announce
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29051189,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,29051189)
	e3:SetTarget(c29051189.actg)
	e3:SetOperation(c29051189.acop)
	c:RegisterEffect(e3)
end
function c29051189.filter(c)
	return c:IsFacedown() and not (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
end
function c29051189.filter2(c)
	return c:IsFaceup() and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
end
function c29051189.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		not Duel.IsExistingMatchingCard(c29051189.filter,c:GetControler(),LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c29051189.filter2,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c29051189.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5) and Duel.GetDecktopGroup(tp,5):FilterCount(Card.IsAbleToHand,nil)>0 end
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
			if g:IsExists(c29051189.filter,1,nil,ac) and Duel.SelectYesNo(tp,aux.Stringid(29051189,1)) then
				Duel.DisableShuffleCheck()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:FilterSelect(tp,c29051189.thfilter,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sg=g:FilterSelect(tp,c29051189.tgfilter,1,1,nil)
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
			
		end
	end
end



