--佩特拉·莱特
local s,id,o=GetID()
local SET_HALF_FIEND = 0x3f50 
function s.initial_effect(c)
	aux.AddFusionProcCode2(c,17337424,17337495,true,true)
	c:EnableReviveLimit()
	if not s.global_check then
		s.global_check=true
		s.op_effect_activated={}
		s.op_effect_activated[0]=false
		s.op_effect_activated[1]=false		
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)	
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_TURN_END)
		ge2:SetOperation(s.clearop)
		Duel.RegisterEffect(ge2,0)
	end
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_EXTRA+LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.pltg)
	e1:SetOperation(s.plop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.trapcon)
	e2:SetTarget(s.traptg)
	e2:SetOperation(s.trapop)
	c:RegisterEffect(e2)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	s.op_effect_activated[rp]=true
end
function s.clearop(e,tp,eg,ep,ev,re,r,rp)
	s.op_effect_activated[0]=false
	s.op_effect_activated[1]=false
end
function s.plfilter(c)
	return c:IsSetCard(SET_HALF_FIEND) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function s.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<3 then return false end
		local g=Duel.GetMatchingGroup(s.plfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,c)
		local deck_g=Duel.GetMatchingGroup(s.plfilter,tp,LOCATION_DECK,0,nil)
		if s.op_effect_activated[1-tp] and #deck_g>0 then
			return #g>=1 
		else
			return #g>=2 
		end
	end
end
function s.plop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<3 then return end	
	local g=Duel.GetMatchingGroup(s.plfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,c)
	local can_deck = s.op_effect_activated[1-tp] and Duel.IsExistingMatchingCard(s.plfilter,tp,LOCATION_DECK,0,1,nil)	
	local sg=Group.CreateGroup()
	if can_deck and #g>=1 and (#g<2 or Duel.SelectYesNo(tp,aux.Stringid(id,2))) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g1=Duel.SelectMatchingCard(tp,s.plfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g2=Duel.SelectMatchingCard(tp,s.plfilter,tp,LOCATION_DECK,0,1,1,nil)
		sg:Merge(g1)
		sg:Merge(g2)
	elseif #g>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		sg=Duel.SelectMatchingCard(tp,s.plfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,2,2,c)
	else
		return
	end	
	sg:AddCard(c) 	
	for tc in aux.Next(sg) do
		if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
		end
	end
end
function s.trapcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function s.op1filter(c,e,tp)
	return c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER>0 and c:IsSetCard(SET_HALF_FIEND) 
		and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function s.op2filter(c,tp)
	local r=LOCATION_REASON_TOFIELD
	if not c:IsControler(tp) then r=LOCATION_REASON_CONTROL end
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and Duel.GetLocationCount(c:GetOwner(),LOCATION_SZONE,tp,r)>0
end
function s.traptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==0 then
			return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and s.op1filter(chkc,e,tp)
		else
			return chkc:IsLocation(LOCATION_MZONE) and s.op2filter(chkc,tp)
		end
	end
	if chk==0 then
		local b1=Duel.IsExistingTarget(s.op1filter,tp,LOCATION_SZONE,0,1,nil,e,tp)
		local b2=Duel.IsExistingTarget(s.op2filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
		return b1 or b2
	end	
	local b1=Duel.IsExistingTarget(s.op1filter,tp,LOCATION_SZONE,0,1,nil,e,tp)
	local b2=Duel.IsExistingTarget(s.op2filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
	local op=0	
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,3))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,4))+1
	end
	e:SetLabel(op)	
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,s.op1filter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,s.op2filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	end
end
function s.trapop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end	
	if e:GetLabel()==0 then
		if not (tc:IsFaceup() and tc:IsLocation(LOCATION_SZONE)) then return end
		local b1=tc:IsAbleToHand()
		local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		if not (b1 or b2) then return end	
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,1190,1152) 
		elseif b1 then
			op=0
		else
			op=1
		end
		if op==0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		if tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
			if Duel.MoveToField(tc,tp,tc:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
				tc:RegisterEffect(e1)
			end
		end
	end
end