--幽魔的异魔神

local s,id=GetID()
s.named_with_Darkling=1

function s.Darkling(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Darkling
end

function s.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1a)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetValue(aux.imval1)
	c:RegisterEffect(e4)
	
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e5)
end

function s.lkcfilter(c,ec,tp)
	if not (c:IsFaceup() and c:IsControler(tp) and s.Darkling(c)) then return false end
	local seq = c:GetSequence()
	local zone_mask = 1 << seq
	local link_zone = ec:GetLinkedZone(tp) & 0x001
	return ec:GetLinkedGroup():IsContains(c) 
		   and (ec:GetLinkMarker() & LINK_MARKER_BOTTOM_LEFT ~= 0) 
		   and s.IsSequenceLinkedByMarker(ec, c, tp, LINK_MARKER_BOTTOM_LEFT)
end

function s.IsSequenceLinkedByMarker(ec, tc, tp, marker)
	local eseq = ec:GetSequence()
	local tseq = tc:GetSequence()
	
	if eseq == 5 then
		if marker == LINK_MARKER_BOTTOM_LEFT and tseq == 0 then return true end
		if marker == LINK_MARKER_BOTTOM_RIGHT and tseq == 2 then return true end
	elseif eseq == 6 then
		if marker == LINK_MARKER_BOTTOM_LEFT and tseq == 2 then return true end
		if marker == LINK_MARKER_BOTTOM_RIGHT and tseq == 4 then return true end
	elseif eseq >= 0 and eseq <= 4 then
		if marker == LINK_MARKER_BOTTOM_LEFT and eseq > 0 and tseq == eseq - 1 then return true end
		if marker == LINK_MARKER_BOTTOM_RIGHT and eseq < 4 and tseq == eseq + 1 then return true end
	end
	return false
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.lkcfilter, 1, nil, e:GetHandler(), tp)
end

function s.spfilter(c,e,tp)
	return s.Darkling(c) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetLinkedGroup()
	return g:IsExists(function(tc)
		return tc:IsFaceup() and tc:IsControler(tp) and s.Darkling(tc) 
		   and s.IsSequenceLinkedByMarker(c, tc, tp, LINK_MARKER_BOTTOM_RIGHT)
	end, 1, nil)
end

function s.tgfilter(c,tp)
	if not (c:IsFaceup() and c:GetAttack()>=0) then return false end
	if c:IsType(TYPE_LINK) then return false end
	
	local val = c:IsType(TYPE_XYZ) and c:GetRank() or c:GetLevel()
	if val == 2 then return false end
	
	local atk = c:GetAttack()
	return Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil,atk)
end

function s.thfilter2(c,atk)
	return s.Darkling(c) and c:IsType(TYPE_MONSTER) and c:GetAttack()>=0 and c:GetAttack()<=atk and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local atk = tc:GetAttack()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK,0,1,1,nil,atk)
		
		if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,g)
			
			if tc:IsFaceup() and tc:IsRelateToEffect(e) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				if tc:IsType(TYPE_XYZ) then
					e1:SetCode(EFFECT_CHANGE_RANK)
				else
					e1:SetCode(EFFECT_CHANGE_LEVEL)
				end
				e1:SetValue(2)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
		end
	end
end
