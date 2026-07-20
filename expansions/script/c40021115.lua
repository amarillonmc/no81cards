--创界神 倪克斯
local s,id=GetID()
s.named_with_Grandwalker=1
s.named_with_Primordial=1
s.COUNTER_DARKLING=0x2f1e

function s.Darkling(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Darkling
end
function s.Grandwalker(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Grandwalker
end
function s.initial_effect(c)

	aux.EnablePendulumAttribute(c)

	c:EnableCounterPermit(s.COUNTER_DARKLING)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(s.addcon)
	e1:SetOperation(s.addop)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1a)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(s.solvecon)
	e2:SetOperation(s.solveop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE_COUNTER+s.COUNTER_DARKLING)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.rmcon)
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)

	if not s.global_check1 then
		s.global_check1=true
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_TO_GRAVE)
		ge3:SetOperation(s.checkop1)
		Duel.RegisterEffect(ge3,0)
	end
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCountLimit(1,id+100)
	e4:SetCondition(s.pzcon)
	e4:SetTarget(s.pztg)
	e4:SetOperation(s.pzop)
	c:RegisterEffect(e4) 
end

function s.addfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and s.Darkling(c)
end

function s.addcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.addfilter,1,nil,tp)
end

function s.addop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(s.COUNTER_DARKLING,1)
end

function s.tgfilter(c)
	if not c:IsFaceup() then return false end
	if c:IsType(TYPE_LINK) then return false end
	
	if c:IsType(TYPE_XYZ) then
		return c:GetRank()>1
	else
		return c:GetLevel()>1
	end
end

function s.solvecon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)>0 then return false end
	return Duel.IsCanRemoveCounter(tp,1,0,s.COUNTER_DARKLING,4,REASON_EFFECT)
		and Duel.IsExistingMatchingCard(s.tgfilter,tp,0,LOCATION_MZONE,1,nil)
end

function s.solveop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,id)==0 
		and Duel.IsCanRemoveCounter(tp,1,0,s.COUNTER_DARKLING,4,REASON_EFFECT)
		and Duel.IsExistingMatchingCard(s.tgfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,1)) then 
		
		Duel.Hint(HINT_CARD,0,id)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		
		Duel.RemoveCounter(tp,1,0,s.COUNTER_DARKLING,4,REASON_EFFECT)
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.HintSelection(g)
			if tc:IsType(TYPE_XYZ) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_RANK)
				e1:SetValue(1)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
			else
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LEVEL)
				e1:SetValue(1)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
			end
		end
	end
end

function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end

function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
end

function s.gravefilter(c)
	if not c:IsFaceup() then return false end
	if c:IsType(TYPE_LINK) then return false end
	if c:IsType(TYPE_XYZ) then
		return c:GetRank()==1
	else
		return c:GetLevel()==1
	end
end

function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,0,LOCATION_MZONE,nil)
	local changed=false
	
	for tc in aux.Next(g) do
		local is_xyz = tc:IsType(TYPE_XYZ)
		local cur_val = is_xyz and tc:GetRank() or tc:GetLevel()
		local new_val = cur_val - 2
		if new_val < 1 then new_val = 1 end
		
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		if is_xyz then e1:SetCode(EFFECT_CHANGE_RANK) else e1:SetCode(EFFECT_CHANGE_LEVEL) end
		e1:SetValue(new_val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		changed=true
	end
	
	if changed then
		local sg=Duel.GetMatchingGroup(s.gravefilter,tp,0,LOCATION_MZONE,nil)
		
		if Duel.IsPlayerAffectedByEffect(tp, 40021121) then
			local link_g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsType(TYPE_LINK) end, tp, 0, LOCATION_MZONE, nil)
			if #link_g>0 then sg:Merge(link_g) end
		end
		
		if Duel.IsPlayerAffectedByEffect(tp, 40021140) then
			local st_g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) end, tp, 0, LOCATION_ONFIELD, nil)
			if #st_g>0 then sg:Merge(st_g) end
		end
		
		if #sg>0 then
			Duel.BreakEffect()
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end

function s.checkop1(e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	local rc=re:GetHandler()
	if s.Grandwalker(rc) and eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_DECK) then
		Duel.RegisterFlagEffect(rp,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.pzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end
function s.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLocation(tp,LOCATION_PZONE,0)
			or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	end
end
function s.pzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		return
	end
	if Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
		if Duel.GetFlagEffect(tp,id)==0 then
			if Duel.IsPlayerCanDiscardDeck(tp,3) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.BreakEffect()
				Duel.DiscardDeck(tp,3,REASON_EFFECT)
			end
		end
	end
end

