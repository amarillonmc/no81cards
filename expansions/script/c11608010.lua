--乱流舞者 由伊
local s,id,o=GetID()
function s.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--hand effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.hcost)
	e1:SetTarget(s.htg)
	e1:SetOperation(s.hop)
	c:RegisterEffect(e1)
	
	--special summon from deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_DECK)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.spcon)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC_G)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_DECK)
	e3:SetCondition(s.spcon)
	c:RegisterEffect(e3)
end
function s.mark_as_faceup(c)
	if c:GetLocation()==LOCATION_DECK then
		c:ReverseInDeck()
		c:RegisterFlagEffect(id+1000,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end

function s.mfilter(c)
	return c:IsSetCard(0x9225) and c:IsType(TYPE_MONSTER)
end

function s.hcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

function s.htg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and
			Duel.IsExistingMatchingCard(s.mfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.hop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	local g=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_DECK,0,nil)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dcount==0 then return end
	
	if g:GetCount()==0 then
		Duel.ConfirmDecktop(tp,dcount)
		return
	end
	
	local seq=-1
	local tc=g:GetFirst()
	local target=nil
	while tc do
		if tc:GetSequence()>seq then
			seq=tc:GetSequence()
			target=tc
		end
		tc=g:GetNext()
	end
	
	local reveal_count = dcount - seq
	Duel.ConfirmDecktop(tp,reveal_count)
	
	local revealed = Duel.GetDecktopGroup(tp, reveal_count)
	
	if target:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(target,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,target)
		
		revealed:RemoveCard(target)
		revealed:AddCard(c)
		
		local return_count = revealed:GetCount()
		if return_count > 0 then
			-- 确保卡片表面向上放回卡组
			for tc in aux.Next(revealed) do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(LOCATION_DECKSHF)
				e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
				tc:RegisterEffect(e1)
			end
			Duel.SendtoDeck(revealed,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
			for tc in aux.Next(revealed) do
				s.mark_as_faceup(tc)
			end
		end
	else
		Duel.ShuffleDeck(tp)
	end
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function s.splimit(e,c)
	return not (c:GetLevel()==7 or c:GetRank()==7)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPosition(POS_FACEUP_ATTACK) or c:IsPosition(POS_FACEUP_DEFENSE)
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		-- 确保卡片表面向上放回卡组
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_DECKSHF)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		tc:RegisterEffect(e1)
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_COST)
		Duel.ShuffleDeck(tp)
		s.mark_as_faceup(tc)
	end
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,e:GetHandler(),1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end