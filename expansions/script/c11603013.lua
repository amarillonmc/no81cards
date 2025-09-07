--封灵师 九儿
local s,id=GetID()
function s.initial_effect(c)
	--place and special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--place
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(aux.NOT(s.effcon))
	e2:SetTarget(s.tftg)
	e2:SetOperation(s.tfop)
	c:RegisterEffect(e2)
	--place
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(s.effcon)
	c:RegisterEffect(e3)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>4  end
end
function s.plfilter(c,tp)
	return c:CheckUniqueOnField(tp,LOCATION_SZONE) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)==0 or ct<=0 then return end
	local sp=false
	Duel.ConfirmDecktop(1-tp,5)
	local g=Duel.GetDecktopGroup(1-tp,5):Filter(s.plfilter,nil,1-tp)
	if #g==0 then return end
	ct=math.min(ct,#g,2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tg=g:Select(tp,1,ct,nil)
	for tc in aux.Next(tg) do
		if tc and Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true) then
			--Treated as a Continuous Spell
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
			sp=true
		end
	end
	if c:IsRelateToEffect(e) and sp and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		--Treated as a Continuous Spell
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetCode(EFFECT_CHANGE_TYPE)
		e4:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		e4:SetReset(RESET_EVENT|RESETS_STANDARD&~RESET_TURN_SET)
		c:RegisterEffect(e4)
	end
	--Cannot Special Summon Monster, except Illusion Monsters
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(function(_,c) return not c:IsRace(RACE_ILLUSION) end)
	e2:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function s.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK,0,1,1,nil)
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
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,11603038)}) do
		fg:AddCard(pe:GetHandler())
	end
	if chk==0 then return #fg>=1 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11603037,0))
	local fc=nil
	if #fg==1 then
		fc=fg:GetFirst()
	else
		fc=fg:Select(tp,1,1,nil)
	end
	Duel.Hint(HINT_CARD,0,fc:GetCode())
	fc:RegisterFlagEffect(11603038,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function s.plfilter2(c)
	return c:IsSetCard(0x6224) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function s.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.plfilter2,tp,LOCATION_DECK,0,1,nil) end
end
function s.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,s.plfilter2,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		--Treated as a Continuous Spell
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD&~RESET_TURN_SET)
		tc:RegisterEffect(e1)
	end
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAllTypes(TYPE_CONTINUOUS+TYPE_TRAP) and Duel.IsPlayerAffectedByEffect(tp,11603037)
end