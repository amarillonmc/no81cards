--苍岚水师 琳
function c33200701.initial_effect(c)
	--SearchCard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200701,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,33200701)
	e1:SetTarget(c33200701.thtg)
	e1:SetOperation(c33200701.thop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200701,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,33200702)
	e2:SetTarget(c33200701.sptg)
	e2:SetOperation(c33200701.spop)
	c:RegisterEffect(e2)
end

--e1
function c33200701.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc32a)
end
function c33200701.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return false end
		local g=Duel.GetDecktopGroup(tp,3)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c33200701.thop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,3)
	local g=Duel.GetDecktopGroup(p,3):Filter(c33200701.thfilter,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(33200701,2)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:Select(p,1,1,nil)
		if sg:GetFirst():IsAbleToHand() then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,sg)
			Duel.ShuffleHand(p)
		end
	end
	Duel.ShuffleDeck(p)
end

--e2
function c33200701.spfilter(c,e,tp)
	local count=c:GetLink()
	return c:IsType(TYPE_LINK) and c:IsSetCard(0xc32a) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x32a,count,REASON_EFFECT)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) 
end
function c33200701.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c33200701.spfilter(chkc,e,tp)  end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33200701.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c33200701.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.ConfirmCards(1-tp,g)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	e:SetLabel(100)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c33200701.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()~=100 then return end
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local count=tc:GetLink()
	if tc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,tc)>0 and Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x32a,count,REASON_EFFECT) then
		if Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,0x32a,count,REASON_EFFECT) then
			Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c33200701.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c33200701.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xc32a) and bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK 
end