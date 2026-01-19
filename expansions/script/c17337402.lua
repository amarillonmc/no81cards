--半魔的公主
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,17337404)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg1)
	e1:SetOperation(s.spop1)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return true
end

function s.elfilter(c)
	return c:IsCode(17337404) and c:IsFaceup()
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.elfilter,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then 
		if b1 then return true end
		local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_EXTRA,0,nil,0x3f50)
		local codes={}
		local tc=g:GetFirst()
		while tc do
			local code=tc:GetCode()
			if not codes[code] then
				codes[code]=true
			end
			tc=g:GetNext()
		end
		local count=0
		for _,_ in pairs(codes) do
			count=count+1
		end
		return count>=7
	end
	if b1 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
		local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_EXTRA,0,nil,0x3f50)
		local sg=Group.CreateGroup()
		local codes={}

		local unique_codes={}
		local tc=g:GetFirst()
		while tc do
			local code=tc:GetCode()
			if not unique_codes[code] then
				unique_codes[code]=true
			end
			tc=g:GetNext()
		end
		local unique_count=0
		for _,_ in pairs(unique_codes) do
			unique_count=unique_count+1
		end
		
		if unique_count<7 then
			return
		end
		
		for i=1,7 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			while sg:IsExists(Card.IsCode,1,nil,tc:GetCode()) do
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
				tc=g:Select(tp,1,1,nil):GetFirst()
			end
			sg:AddCard(tc)
			table.insert(codes,tc:GetCode())
			g:Remove(Card.IsCode,nil,tc:GetCode())
		end
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleExtra(tp)
	end
end

function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if e:GetLabel()==0 then
			local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_EXTRA,0,nil,0x3f50)
			local codes={}
			local tc=g:GetFirst()
			while tc do
				local code=tc:GetCode()
				if not codes[code] then
					codes[code]=true
				end
				tc=g:GetNext()
			end
			local count=0
			for _,_ in pairs(codes) do
				count=count+1
			end
			if count<7 then return false end
		end
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function s.thfilter(c)
	return c:IsSetCard(0x3f50) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsAbleToHand() or c:IsSSetable())
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc)
		end
	end
end