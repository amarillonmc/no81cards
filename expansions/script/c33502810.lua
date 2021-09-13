--魔女之旅·归忆碎片
function c33502810.initial_effect(c)
--
	aux.AddCodeList(c,33502800)
	aux.AddCodeList(c,75640050)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c33502810.handcon)
	c:RegisterEffect(e0)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33502810,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(c33502810.tg2)
	e2:SetOperation(c33502810.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33502810,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCountLimit(1,33502810)
	e3:SetLabel(0)
	e3:SetCost(c33502810.cost3)
	e3:SetTarget(c33502810.tg3)
	e3:SetOperation(c33502810.op3)
	c:RegisterEffect(e3)
--
end
--
function c33502810.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_EXTRA)<1
end
--
function c33502810.tfilter1_1(c,rc)
	return c:GetRitualLevel(rc)>=rc:GetLevel()
end
function c33502810.tfilter1_2(c)
	return aux.IsCodeListed(c,33502800) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGrave()
end
function c33502810.tfilter1(c,e,tp,mg)
	if bit.band(c:GetType(),0x81)~=0x81
		or not aux.IsCodeListed(c,33502800)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local lg=mg:Filter(Card.IsCanBeRitualMaterial,c,c)
	return mg:IsExists(c33502810.tfilter1_1,1,nil,c)
		or Duel.IsExistingMatchingCard(c33502810.tfilter1_2,tp,LOCATION_SZONE,0,1,nil)
end
function c33502810.CheckFilter(c)
	return c:IsAbleToGrave() and c:IsCode(33502800)
end
function c33502810.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetRitualMaterial(tp)
	if chk==0 then return Duel.IsExistingMatchingCard(c33502810.CheckFilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c33502810.tfilter1,tp,LOCATION_HAND,0,1,nil,e,tp,mg) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
--
function c33502810.ofilter1(c,e,tp,mg,tc)
	local b1=c:IsLocation(LOCATION_MZONE+LOCATION_HAND)
		and c:GetRitualLevel(tc)>=tc:GetLevel()
	local b2=c:IsLocation(LOCATION_SZONE)
		and aux.IsCodeListed(c,33502800) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGrave()
	return (b1 or b2) and Duel.GetMZoneCount(tp,c)>0
end
function c33502810.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c33502810.CheckFilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<1 then return end
	if Duel.SendtoGrave(g,REASON_EFFECT)<1 then return end
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c33502810.tfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg)
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local lg=Duel.SelectMatchingCard(tp,c33502810.ofilter1,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,tc,e,tp,mg,tc)
		if lg:GetCount()<1 then return end
		tc:SetMaterial(lg)
		local lc=lg:GetFirst()
		local ng=Group.CreateGroup()
		while lc do
			if lc:IsType(TYPE_MONSTER) then ng:AddCard(lc) end
			lc=lg:GetNext()
		end
		if ng:GetCount()>0 then
			lg:Sub(ng)
			Duel.ReleaseRitualMaterial(ng)
		end
		if lg:GetCount()>0 then
			Duel.SendtoGrave(lg,REASON_EFFECT)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		local e1_1=Effect.CreateEffect(e:GetHandler())
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_CHANGE_CODE)
		e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1_1:SetValue(75640050)
		e1_1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1_1)
	end
end
--
function c33502810.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
--
function c33502810.tfilter3_1(c,tp)
	return aux.IsCodeListed(c,33502800) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToHandAsCost()
		and Duel.IsExistingMatchingCard(c33502810.tfilter3_2,tp,LOCATION_DECK,0,1,nil,c)
end
function c33502810.tfilter3_2(c,tc)
	return aux.IsCodeListed(c,33502800) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and not c:IsCode(tc:GetCode())
end
function c33502810.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c33502810.tfilter3_1,tp,LOCATION_SZONE,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=Duel.SelectMatchingCard(tp,c33502810.tfilter3_1,tp,LOCATION_SZONE,0,1,1,nil,tp)
	local tc=sg:GetFirst()
	Duel.SendtoHand(tc,nil,REASON_COST)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c33502810.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33502810.tfilter3_2,tp,LOCATION_DECK,0,1,1,nil,tc)
	if g:GetCount()<1 then return end
	if Duel.SendtoHand(g,nil,REASON_EFFECT)<1 then return end
	Duel.ConfirmCards(1-tp,g)
	if c:GetOriginalCode()==33502801 then
		local e3_3=Effect.CreateEffect(c)
		e3_3:SetDescription(aux.Stringid(33502801,2))
		e3_3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e3_3:SetType(EFFECT_TYPE_FIELD)
		e3_3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e3_3:SetRange(LOCATION_SZONE)
		e3_3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3_3:SetValue(1)
		e3_3:SetTarget(c33502810.tg3_3)
		e3_3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3_3)
	end
	if c:GetOriginalCode()==33502802 then
		local e3_4=Effect.CreateEffect(c)
		e3_4:SetDescription(aux.Stringid(33502801,3))
		e3_4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e3_4:SetType(EFFECT_TYPE_FIELD)
		e3_4:SetCode(EFFECT_CANNOT_TO_DECK)
		e3_4:SetRange(LOCATION_SZONE)
		e3_4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3_4:SetTargetRange(0,1)
		e3_4:SetTarget(function(e,c) return c:IsOnField() end)
		e3_4:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3_4)
	end
	if c:GetOriginalCode()==33502803 then
		local e3_5=Effect.CreateEffect(c)
		e3_5:SetDescription(aux.Stringid(33502801,4))
		e3_5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e3_5:SetType(EFFECT_TYPE_FIELD)
		e3_5:SetCode(EFFECT_CANNOT_REMOVE)
		e3_5:SetRange(LOCATION_SZONE)
		e3_5:SetTargetRange(0,LOCATION_GRAVE)
		e3_5:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3_5)
	end
	if c:GetOriginalCode()==33502804 then
		local e3_6=Effect.CreateEffect(c)
		e3_6:SetDescription(aux.Stringid(33502801,5))
		e3_6:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e3_6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3_6:SetCode(EVENT_CHAINING)
		e3_6:SetRange(LOCATION_SZONE)
		e3_6:SetOperation(c33502810.op3_6)
		e3_6:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3_6)
	end
end
function c33502810.tg3_3(e,c)
	return e:GetHandler():GetColumnGroup():IsContains(c)
end
function c33502810.op3_6(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(aux.FALSE)
end
--
