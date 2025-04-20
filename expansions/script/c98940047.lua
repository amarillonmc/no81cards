--未界域大暴动
local s,id,o=GetID()
function c98940047.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetRange(LOCATION_DECK)
	c:RegisterEffect(e0)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98940047,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c98940047.spcost)
	e2:SetTarget(c98940047.sptg)
	e2:SetOperation(c98940047.spop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(0xff)
	e3:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e3:SetTarget(c98940047.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
--activate from hand
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(98940047,0))
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e11:SetRange(0xff)
	e11:SetCondition(c98940047.condition)
	e11:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x11e))
	e11:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e11)
	local e21=e11:Clone()
	e21:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e21)
   --change effect type
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD)
	e14:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e14:SetCode(98940047)
	e14:SetRange(0xff)
	e14:SetCondition(c98940047.condition)
	e14:SetTargetRange(1,0)
	c:RegisterEffect(e14)
	--to deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetTarget(s.tdtg)
	e4:SetOperation(s.tdop)
	c:RegisterEffect(e4)
if not c98940047.globle_check then
		c98940047.globle_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_ACTIVATE_COST)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetCost(c98940047.costchk)
		ge1:SetTargetRange(1,0)
		ge1:SetTarget(c98940047.actarget)
		ge1:SetOperation(c98940047.costop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD)
		ge3:SetCode(EFFECT_ACTIVATE_COST)
		ge3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge3:SetCost(aux.FALSE)
		ge3:SetTargetRange(1,1)
		ge3:SetTarget(c98940047.actarget2)
		Duel.RegisterEffect(ge3,0)
		local g=Duel.GetMatchingGroup(c98940047.filter2,0,0xff,0xff,nil)
		for tc in aux.Next(g) do
			local te=tc:GetActivateEffect()
			local ge2=te:Clone()
			ge2:SetDescription(aux.Stringid(98940047,1))
			ge2:SetType(EFFECT_TYPE_QUICK_O)
			ge2:SetCode(EVENT_FREE_CHAIN)
			ge2:SetRange(LOCATION_HAND)
			ge2:SetHintTiming(TIMING_STANDBY_PHASE+TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
			tc:RegisterEffect(ge2)
		end
	end
end
function c98940047.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),98940047)>0
end
function c98940047.eftg(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x11e) and Duel.GetFlagEffect(e:GetHandlerPlayer(),98940047)>0
end
function s.cfilter(c)
	local b2=c:IsSetCard(0x11e) and c:IsType(TYPE_MONSTER)
	return not c:IsPublic() and b2
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	if e:GetHandler():IsLocation(LOCATION_DECK) then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	Duel.RegisterFlagEffect(e:GetHandlerPlayer(),98940047,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3)
		and Duel.GetDecktopGroup(tp,3):FilterCount(Card.IsAbleToHand,nil)>0 and Duel.GetFlagEffect(tp,id+o)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
	Duel.RegisterFlagEffect(tp,id+o,RESET_CHAIN,EFFECT_FLAG_OATH,1)
end
function c98940047.tggfilter(c)
	return c:IsSetCard(0x11e) and c:IsAbleToHand()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDiscardDeck(tp,3) then
		Duel.ConfirmDecktop(tp,3)
		local g=Duel.GetDecktopGroup(tp,3)
		if g:GetCount()>0 then
			if g:IsExists(c98940047.tggfilter,1,nil) then
				Duel.DisableShuffleCheck()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:FilterSelect(tp,c98940047.tggfilter,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
				Duel.ShuffleDeck(tp)
				if sg:GetCount()>0 and Duel.IsExistingMatchingCard(c98940047.lkfilter,tp,LOCATION_EXTRA,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local lg=Duel.SelectMatchingCard(tp,c98940047.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil)
					local tc=lg:GetFirst()
				  	if tc:IsType(TYPE_LINK) then
						Duel.LinkSummon(tp,tc,nil)
					else 
						Duel.XyzSummon(tp,tc,nil)			
					end
				end
			else
				Duel.ShuffleDeck(tp)
			end
		end
	end
end
function c98940047.lkfilter(c)
	return c:IsLinkSummonable(nil) or c:IsXyzSummonable(nil)
end
function c98940047.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not e:GetHandler():IsPublic() and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c98940047.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98940047.rfilter(c,code)
	return c:IsCode(code) and c:IsFaceup()
end
function c98940047.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c98940047.spop(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetHandler():GetCode()
	if Duel.IsExistingMatchingCard(c98940047.rfilter,tp,LOCATION_REMOVED,0,1,nil,code) then
		local sgv=Duel.GetMatchingGroup(c98940047.rfilter,tp,LOCATION_REMOVED,0,nil,code)
		local ssg=sgv:GetFirst()
		Duel.SendtoHand(ssg,nil,REASON_EFFECT)
	end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if #g<1 then return end
	local tc=g:RandomSelect(1-tp,1):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_DISCARD+REASON_EFFECT)~=0 and not tc:IsCode(code)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local spg=Duel.GetMatchingGroup(c98940047.spfilter,tp,LOCATION_HAND,0,nil,e,tp,code)
		if spg:GetCount()<=0 then return end
		local sg=spg
		if spg:GetCount()~=1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg=spg:Select(tp,1,1,nil)
		end
		Duel.BreakEffect()
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c98940047.costchk(e,te_or_c,tp)
	return Duel.IsPlayerAffectedByEffect(tp,98940047) 
end
function c98940047.actarget(e,te,tp)
	local tc=te:GetHandler()
	e:SetLabelObject(te)
	return tc:IsSetCard(0x11e) and te:IsHasType(EFFECT_TYPE_QUICK_O) and tc:IsLocation(LOCATION_HAND) and not tc:IsType(TYPE_MONSTER)
end
function c98940047.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	local tp=te:GetHandlerPlayer()
	te:SetType(EFFECT_TYPE_ACTIVATE)
	if tc:IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,false)
	elseif tc:IsType(TYPE_SPELL+TYPE_TRAP) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	end
	local ge3=Effect.CreateEffect(tc)
	ge3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	ge3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	ge3:SetCode(EVENT_CHAIN_SOLVED)
	ge3:SetLabelObject(te)
	ge3:SetReset(RESET_PHASE+PHASE_END)
	ge3:SetOperation(c98940047.resetop)
	Duel.RegisterEffect(ge3,tp)
	local ge4=ge3:Clone()
	ge4:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(ge4,tp)
end
function c98940047.actarget2(e,te,tp)
	local tc=te:GetHandler()
	return tc:IsSetCard(0x11e) and te:IsHasType(EFFECT_TYPE_QUICK_O) and tc:IsLocation(LOCATION_SZONE)
end
function c98940047.resetop(e,tp,eg,ep,ev,re,r,rp)
	if re==e:GetLabelObject() and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		re:SetType(EFFECT_TYPE_QUICK_O)
		e:Reset()
	end
end
function c98940047.filter2(c)
	return c:IsSetCard(0x11e) and c:IsType(TYPE_SPELL) and not c:IsType(TYPE_QUICKPLAY) 
end
function s.tdfilter(c)
	return c:IsSetCard(0x11e) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and c:IsFaceupEx()
end
function s.fselect(g)
	return g:GetClassCount(Card.GetRace)==g:GetCount()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.tdfilter(chkc) end
	if chk==0 then return c:IsAbleToDeck()
		and Duel.IsExistingTarget(s.tdfilter,tp,LOCATION_GRAVE,0,3,nil) and Duel.GetFlagEffect(tp,id+o*2)==0 end
	Duel.RegisterFlagEffect(tp,id+o*2,RESET_CHAIN,EFFECT_FLAG_OATH,1)
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE,0,c,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=g:SelectSubGroup(tp,s.fselect,false,3,3)
	tg:AddCard(c)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetTargetsRelateToChain():Filter(aux.NecroValleyFilter(aux.TRUE),nil)
	if #sg==0 then return end
	if not c:IsRelateToEffect(e) or not aux.NecroValleyFilter()(c) then return end
	sg:AddCard(c)
	aux.PlaceCardsOnDeckBottom(tp,sg)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end