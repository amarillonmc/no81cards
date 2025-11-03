--乱流舞者予你以星
local s,id,o=GetID()
function s.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	
	--negate and draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.negcost)
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	c:RegisterEffect(e1)
	
	--return to deck during end phase
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.rtdtg)
	e2:SetOperation(s.rtdop)
	c:RegisterEffect(e2)
	
	--add to hand from deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_DECK)
	e3:SetCountLimit(1,id+o*2)
	e3:SetCondition(s.athcon)
	e3:SetCost(s.athcost)
	e3:SetTarget(s.athtg)
	e3:SetOperation(s.athop)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC_G)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_DECK)
	e3:SetCondition(s.athcon)
	c:RegisterEffect(e3)
end
function s.mark_as_faceup(c)
	c:ReverseInDeck()
	c:RegisterFlagEffect(id+1000,RESET_EVENT+RESETS_STANDARD,0,1)
end

function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	local g=Duel.GetMatchingGroup(Card.CheckRemoveOverlayCard,tp,LOCATION_MZONE,0,nil,tp,1,REASON_COST)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		local og=tc:GetOverlayGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
		local sg=og:Select(tp,1,1,nil)
		local rc=sg:GetFirst()
		Duel.SendtoGrave(rc,REASON_COST)
		if rc:IsSetCard(0x9225) then
			e:SetLabel(1)
		else
			e:SetLabel(0)
		end
	end
end

function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and aux.NegateAnyFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	if e:GetLabel()==1 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
		-- 添加选择是否抽卡的判断
		if e:GetLabel()==1 and Duel.IsPlayerCanDraw(tp,1) then
			Duel.BreakEffect()
			if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end

function s.rtdfilter(c)
	return (c:IsSetCard(0x9225) or (c:IsType(TYPE_XYZ) and c:IsRank(7))) and c:IsAbleToDeck()
end

function s.rtdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rtdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	local g=Duel.GetMatchingGroup(s.rtdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local ct=math.min(5,g:GetCount())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,ct,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end

function s.rtdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.rtdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if g:GetCount()==0 then return end
	local ct=math.min(5,g:GetCount())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,1,ct,nil)
	if sg:GetCount()>0 then
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		for tc in aux.Next(sg) do
			s.mark_as_faceup(tc)
		end
	end
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
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,e:GetHandler(),1,0,0)
end

function s.athop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end