--乱流舞者 科莱
local s,id,o=GetID()
function s.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--special summon effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
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
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)
	
	-- 保留全局效果
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_END)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local g=Duel.GetMatchingGroup(Card.IsPosition,p,LOCATION_DECK,0,nil,POS_FACEUP_DEFENSE)
		local g2=Duel.GetFieldGroup(p,LOCATION_EXTRA,0)
		if #g2>0 then
			Duel.ConfirmCards(p,g+g2,true)
		end
	end
end

function s.mark_as_faceup(c)
	if c:GetLocation()==LOCATION_DECK then
		c:ReverseInDeck()
		c:RegisterFlagEffect(id+1000,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	local g=Duel.GetDecktopGroup(tp,3)
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
	if #sg>0 then
		if Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,sg)
			g:Sub(sg)
			if #g>0 then
				-- 确保卡片表面向上放回卡组
				for tc in aux.Next(g) do
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetValue(LOCATION_DECKSHF)
					e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
					tc:RegisterEffect(e1)
				end
				Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
				Duel.ShuffleDeck(tp)
				for tc in aux.Next(g) do
					s.mark_as_faceup(tc)
				end
			end
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
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

function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,e:GetHandler(),1,0,0)
end

function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end