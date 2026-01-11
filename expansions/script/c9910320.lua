--神树勇者 犬吠埼风
function c9910320.initial_effect(c)
	aux.AddCodeList(c,9910307)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9910320)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c9910320.thtg)
	e1:SetOperation(c9910320.thop)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c9910320.sumop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c9910320.thfilter(c)
	return c:IsCode(9910307) and c:IsAbleToHand()
end
function c9910320.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	Duel.SetTargetPlayer(tp)
end
function c9910320.thfilter(c)
	return ((c:IsSetCard(0x5956) and c:IsType(TYPE_MONSTER)) or (c:IsSetCard(0x3956) and c:IsType(TYPE_SPELL+TYPE_TRAP)))
		and c:IsAbleToHand()
end
function c9910320.thop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dct=Duel.GetFieldGroupCount(p,LOCATION_DECK,0)
	if dct<3 then return end
	local op=0
	if dct>=5 and Duel.IsEnvironment(9910307,PLAYER_ALL,LOCATION_FZONE) then
		op=Duel.SelectOption(tp,aux.Stringid(9910320,0),aux.Stringid(9910320,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(9910320,0))
	end
	local ct= op==0 and 3 or 5
	Duel.ConfirmDecktop(p,ct)
	local g=Duel.GetDecktopGroup(p,ct)
	local tg=g:Filter(c9910320.thfilter,nil)
	if #tg>0 and Duel.SelectYesNo(p,aux.Stringid(9910320,2)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=tg:Select(p,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-p,sg)
	end
	Duel.ShuffleDeck(p)
end
function c9910320.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,9910320)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(9910320,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,9910320,RESET_PHASE+PHASE_END,0,1)
end
