--结 缘 之 神 -大 国 主
local m=130006043
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),aux.NonTuner(Card.IsAttribute,ATTRIBUTE_DARK),2)
	c:EnableReviveLimit()
	aux.AddCodeList(c,130006046)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c130006043.limcon)
	e1:SetOperation(c130006043.limop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetOperation(c130006043.limop2)
	c:RegisterEffect(e2)
	--sp th sc
	local e3=Effect.CreateEffect(c)
--  e3:SetDescription(aux.Stringid(130006043,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c130006043.ststg)
	e3:SetOperation(c130006043.stsop)
	c:RegisterEffect(e3)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c130006043.stscon)
	e4:SetTarget(c130006043.ststg)
	e4:SetOperation(c130006043.stsop2)
	c:RegisterEffect(e4)
	
end
function c130006043.stscon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c130006043.thfilter(c)
	return c:IsAbleToHand() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c130006043.ststg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c130006043.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c130006043.scfilter(c)
	return aux.IsCodeListed(c,130006046) and c:IsType(TYPE_MONSTER)
end
function c130006043.sccfilter(c)
	return aux.IsCodeListed(c,130006046) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c130006043.stsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsCanBeSpecialSummoned),tp,0,LOCATION_GRAVE+LOCATION_HAND,nil,e,0,1-tp,false,false)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and #tg>0 and Duel.SelectYesNo(1-tp,aux.Stringid(130006043,2)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local tc=tg:Select(1-tp,1,1,nil):GetFirst()
		Duel.SpecialSummon(tc,0,1-tp,1-tp,false,false,POS_FACEUP)
	local ttg=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,0,nil)
	local b1=g1:GetCount()>0
	local b2=g2:GetCount()>0
	if b1 or b2 then
		Duel.BreakEffect()
	if b1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		ttg:Merge(sg1)
	end
	if b2 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RTOHAND)
		local sg2=g2:Select(1-tp,1,1,nil)
		ttg:Merge(sg2)
	end
	if ttg:GetCount()>0 then
		Duel.HintSelection(ttg)
		Duel.SendtoHand(ttg,nil,REASON_EFFECT)
		local tttg=Duel.GetOperatedGroup()
		if tttg:IsExists(c130006043.scfilter,1,nil) and Duel.IsExistingMatchingCard(c130006043.sccfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(130006043,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c130006043.sccfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
	end
end
end
function c130006043.stsop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsCanBeSpecialSummoned),tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,e,0,tp,false,false)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(130006043,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=tg:Select(tp,1,1,nil):GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	local ttg=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,0,nil)
	local b1=g1:GetCount()>0
	local b2=g2:GetCount()>0
	if b1 or b2 then
		Duel.BreakEffect()
	if b1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		ttg:Merge(sg1)
	end
	if b2 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RTOHAND)
		local sg2=g2:Select(1-tp,1,1,nil)
		ttg:Merge(sg2)
	end
	if ttg:GetCount()>0 then
		Duel.HintSelection(ttg)
		Duel.SendtoHand(ttg,nil,REASON_EFFECT)
		local tttg=Duel.GetOperatedGroup()
		if tttg:IsExists(c130006043.scfilter,1,nil) and Duel.IsExistingMatchingCard(c130006043.sccfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(130006043,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c130006043.sccfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
	end
end
end

function c130006043.limfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c130006043.limcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c130006043.limfilter,1,nil,tp)
end
function c130006043.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(c130006043.chainlm)
	elseif Duel.GetCurrentChain()==1 then
		e:GetHandler():RegisterFlagEffect(130006043,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(c130006043.resetop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_BREAK_EFFECT)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
	end
end
function c130006043.resetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(130006043)
	e:Reset()
end
function c130006043.limop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetOverlayCount()>0 and e:GetHandler():GetFlagEffect(130006043)~=0 then
		Duel.SetChainLimitTillChainEnd(c130006043.chainlm)
	end
	e:GetHandler():ResetFlagEffect(130006043)
end
function c130006043.chainlm(e,rp,tp)
	return tp==rp
end


