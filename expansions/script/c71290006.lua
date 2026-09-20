--火花-狂欢企划-
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,71290002)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e1b=e1:Clone()
	e1b:SetType(EFFECT_TYPE_QUICK_O)
	e1b:SetCode(EVENT_FREE_CHAIN)
	e1b:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1b:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e1b:SetCondition(s.spcon2)
	c:RegisterEffect(e1b)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DICE+CATEGORY_RECOVER+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2b)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCondition(s.ahacon)
	e3:SetTarget(s.ahatg)
	e3:SetOperation(s.ahaop)
	c:RegisterEffect(e3)
end
function s.ahafilter(c)
	return aux.IsCodeListed(c,71290002) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
--e1
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.ahafilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>=3
		and Duel.IsExistingMatchingCard(s.ahafilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--e2
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function s.gyfilter(c)
	return c:IsAbleToHand()
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sg=g:Select(tp,1,#g,nil)
	local ct=Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	if ct==0 then return end
	local num=table.pack(Duel.TossDice(tp,ct))
	for i=1,ct do
		local d=num[i]
		if d==99 then
			local ohg=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
			if #ohg>0 then
				if not c:IsRelateToEffect(e) then return end
				Duel.ConfirmCards(tp,ohg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local tc=ohg:Select(tp,0,1,nil):GetFirst()
				if tc and Duel.SendtoHand(tc,tp,REASON_EFFECT)~=0 then
					Duel.ConfirmCards(1-tp,tc)
					if c:IsLocation(LOCATION_MZONE) and c:IsAbleToHand() then
						Duel.SendtoHand(c,nil,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,c)
					end
				end
				Duel.ShuffleHand(1-tp)
			end
		elseif d<=3 then
			Duel.Recover(tp,1000,REASON_EFFECT)
			Duel.Recover(1-tp,1000,REASON_EFFECT)
			if c:IsLocation(LOCATION_MZONE) and c:IsAbleToHand()
				and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
				Duel.SendtoHand(c,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,c)
			end
		else
			if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.gyfilter),tp,LOCATION_GRAVE,0,1,nil) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local rg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.gyfilter),tp,LOCATION_GRAVE,0,1,1,nil)
				if #rg>0 then
					Duel.SendtoHand(rg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,rg)
				end
			end
		end
	end
end
--e3
function s.ahacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),71290002)~=0
end
function s.ahatg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand()
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.ahaop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local tf=false
		if c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
			tf=true
		elseif c:IsAbleToHand() then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,c)
			tf=true
		end
		if tf==false then return end
		local chain=Duel.GetCurrentChain()
		local num=0
		if chain<3 then num=1
		else
			while chain>=3 do
				num=num+1
				chain=chain-3
			end
		end
		Duel.Recover(tp,800*num,REASON_EFFECT)
	end
end
