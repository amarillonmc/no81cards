--乱流舞者 尤可
local s,id,o=GetID()
function s.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	
	--search when normal summoned
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
	--add to hand from deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_DECK)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.athcon)
	e2:SetCost(s.athcost)
	e2:SetTarget(s.athtg)
	e2:SetOperation(s.athop)
	c:RegisterEffect(e2)
	
	-- 添加全局效果：连锁结束时检查卡组表侧卡
	if not ConfirmCheck then
		ConfirmCheck=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_END)
		ge1:SetOperation(s.regcon)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
-- 连锁结束时检查是否有表侧卡的条件
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsPosition,p,LOCATION_DECK,LOCATION_DECK,nil,POS_FACEUP_DEFENSE)>0
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
	c:ReverseInDeck()
	c:RegisterFlagEffect(id+1000,RESET_EVENT+RESETS_STANDARD,0,1)
end

function s.thfilter(c)
	return c:IsSetCard(0x9225) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(7)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e2:SetTargetRange(1,0)
			e2:SetTarget(s.splimit)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end
	end
end

function s.splimit(e,c)
	return not (c:GetLevel()==7 or c:GetRank()==7)
end

function s.athcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPosition(POS_FACEUP_ATTACK) or c:IsPosition(POS_FACEUP_DEFENSE) then
		local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
		local faceup_cards=Group.CreateGroup()
		for tc in aux.Next(g) do
			if tc:GetFlagEffect(id+1000)>0 then
				faceup_cards:AddCard(tc)
			end
		end
		if faceup_cards:GetCount()>0 then
			Duel.ConfirmCards(tp,faceup_cards)
			Duel.ConfirmCards(1-tp,faceup_cards)
		end
		return true
	end
	return false
end

function s.athcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_COST)
		Duel.ShuffleDeck(tp)
		s.mark_as_faceup(tc)
	end
end

function s.athtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end

function s.athop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end