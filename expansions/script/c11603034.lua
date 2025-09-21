--封灵月转轮
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,11603019)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(s.tdcost2)
	e2:SetTarget(s.tdtg2)
	e2:SetOperation(s.tdop2)
	c:RegisterEffect(e2)
end
function s.spfilter(c,e,tp,ft)
	if not (c:IsFaceupEx() and c:IsSetCard(0x6224) and c:GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER) then return false end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not c:IsLocation(LOCATION_MZONE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		return true
	end
	if ft>0 and not c:IsLocation(LOCATION_SZONE) and c:CheckUniqueOnField(tp,LOCATION_SZONE) and (c:IsLocation(LOCATION_MZONE) or not c:IsForbidden()) then
		return true
	end
	return false
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if e:GetHandler():IsLocation(LOCATION_HAND) then ft=ft-1 end
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND|LOCATION_GRAVE|LOCATION_ONFIELD,0,1,nil,e,tp,ft) end
end
function s.filter(c)
	return c:IsFaceup() and c:IsCode(11603019)
end
function s.plfilter(c,tp)
	return c:CheckUniqueOnField(tp,LOCATION_SZONE) and c:IsType(TYPE_MONSTER)
end
function s.seqfilter(c,dis)
	return 1<<c:GetSequence()==dis
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if e:GetHandler():IsLocation(LOCATION_HAND) then ft=ft-1 end
	local sp=false
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND|LOCATION_GRAVE|LOCATION_ONFIELD,0,1,1,nil,e,tp,ft):GetFirst()
	if sc then
		Duel.HintSelection(Group.FromCards(sc))
		local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not sc:IsLocation(LOCATION_MZONE)
		local b2=ft>0 and not sc:IsLocation(LOCATION_SZONE)
		local op=0
		op=aux.SelectFromOptions(tp,{b1,aux.Stringid(id,3)},{b2,aux.Stringid(id,4)})
		if op==1 and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			sp=true
		elseif op==2 then
			if Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
				--Treated as a Continuous Spell
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
				e1:SetReset(RESET_EVENT|RESETS_STANDARD&~RESET_TURN_SET)
				sc:RegisterEffect(e1)   
				sp=true
			end
		end
	end
	if not sp then return end
	if Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(s.plfilter,tp,0,LOCATION_MZONE,1,nil,1-tp) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,s.plfilter,tp,0,LOCATION_MZONE,1,1,nil,1-tp):GetFirst()
		if tc then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local dis=Duel.SelectField(tp,1,0,LOCATION_SZONE,0x20002000)
			dis=((dis&0xffff)<<24)|((dis>>24)&0xffff)
			local dg=Duel.GetMatchingGroup(s.seqfilter,tp,0,LOCATION_SZONE,nil,dis)
			if #dg>0 then
				Duel.Destroy(dg,REASON_RULE)
			end
			if Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true,dis) then
				--Treated as a Continuous Spell
				local c=e:GetHandler()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
				e1:SetReset(RESET_EVENT|RESETS_STANDARD&~RESET_TURN_SET)
				tc:RegisterEffect(e1)
				--Add this card to the deck
				local e2=Effect.CreateEffect(c)
				e2:SetDescription(aux.Stringid(id,2))
				e2:SetCategory(CATEGORY_TODECK)
				e2:SetType(EFFECT_TYPE_IGNITION)
				e2:SetRange(LOCATION_SZONE)
				e2:SetCountLimit(1,id)
				if tc:IsOriginalSetCard(0x6224) then
					e2:SetCondition(aux.NOT(s.effcon))
				end
				e2:SetCost(s.tdcost)
				e2:SetTarget(s.tdtg)
				e2:SetOperation(s.tdop)
				e2:SetReset(RESET_EVENT|RESETS_STANDARD&~RESET_TURN_SET)
				tc:RegisterEffect(e2)
				if tc:IsOriginalSetCard(0x6224) then
					local e3=e2:Clone()
					e3:SetType(EFFECT_TYPE_QUICK_O)
					e3:SetCode(EVENT_FREE_CHAIN)
					e3:SetCondition(s.effcon)
					c:RegisterEffect(e3)
				end
			end
		end
	end
end
function s.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	end
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	c:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAllTypes(TYPE_CONTINUOUS+TYPE_TRAP) and Duel.IsPlayerAffectedByEffect(tp,11603037)
end
function s.tdcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function s.tdfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x6224) and c:IsAbleToDeck()
end
function s.tdtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter2,tp,LOCATION_GRAVE|LOCATION_SZONE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_GRAVE|LOCATION_SZONE)
end
function s.tdop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.tdfilter2),tp,LOCATION_GRAVE|LOCATION_SZONE,0,nil)
	if #g>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,4,nil)
		Duel.HintSelection(sg)
		if Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==4 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end