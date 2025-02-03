--skip-夏目凛
function c36700105.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,36700105+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c36700105.hspcon)
	e1:SetValue(c36700105.hspval)
	c:RegisterEffect(e1)
	--check and set
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(TIMING_MAIN_END)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,36700105)
	e2:SetCondition(c36700105.setcon)
	e2:SetTarget(c36700105.settg)
	e2:SetOperation(c36700105.setop)
	c:RegisterEffect(e2)
end
function c36700105.cfilter(c)
	return c:IsSetCard(0xc22) and c:IsFaceup()
end
function c36700105.getzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(c36700105.cfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local seq=tc:GetSequence()
		if seq==5 or seq==6 then
			zone=zone|(1<<aux.MZoneSequence(seq))
		else
			if seq>0 then zone=zone|(1<<(seq-1)) end
			if seq<4 then zone=zone|(1<<(seq+1)) end
		end
	end
	return zone
end
function c36700105.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=c36700105.getzone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c36700105.hspval(e,c)
	local tp=c:GetControler()
	return 0,c36700105.getzone(tp)
end
function c36700105.setcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c36700105.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5
		or Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=5 end
end
function c36700105.thfilter(c)
	return c:IsSetCard(0xc22) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsAbleToHand() or c:IsSSetable())
end
function c36700105.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(0,LOCATION_DECK,0)<5 and Duel.GetFieldGroupCount(0,0,LOCATION_DECK)<5 then return end
	if Duel.GetFieldGroupCount(0,LOCATION_DECK,0)>=5 and Duel.GetFieldGroupCount(0,0,LOCATION_DECK)>=5 then
		local st=Duel.SelectOption(tp,aux.Stringid(36700105,0),aux.Stringid(36700105,1))
		if st==0 then Duel.SortDecktop(tp,tp,5) else Duel.SortDecktop(tp,1-tp,5) end
	elseif Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 then
		Duel.SortDecktop(tp,tp,5)
	elseif Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=5 then
		Duel.SortDecktop(tp,1-tp,5)
	end
	if Duel.IsExistingMatchingCard(c36700105.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 and Duel.SelectYesNo(tp,aux.Stringid(36700105,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
		local ac=Duel.AnnounceType(tp)
		Duel.ConfirmDecktop(1-tp,1)
		local g=Duel.GetDecktopGroup(1-tp,1)
		local cc=g:GetFirst()
		if not ((ac==0 and cc:IsType(TYPE_MONSTER)) or (ac==1 and cc:IsType(TYPE_SPELL)) or (ac==2 and cc:IsType(TYPE_TRAP))) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=Duel.SelectMatchingCard(tp,c36700105.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if tc then
			if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SSet(tp,tc)
			end
		end
	end
end
