--圣夜骑士团·欧洛拉耶尔
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),4,2,s.ovfilter,aux.Stringid(id,0),2,s.xyzop)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE+TIMING_STANDBY_PHASE)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x159) and not c:IsCode(id)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.filter(c)
	return c:IsSetCard(0x159) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		if tc:IsType(TYPE_TRAP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		elseif tc:IsType(TYPE_QUICKPLAY) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		else
			local eff=tc:GetActivateEffect()
			local eff2=eff:Clone()
			eff:SetDescription(aux.Stringid(id,2))
			eff2:SetProperty(eff2:GetProperty(),EFFECT_FLAG2_COF)
			eff2:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
			eff2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(eff2)
		end
		local sg=s.getsearchgroup(tc,e,tp,eg,ep,ev,re,r,rp)
		if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local hg=sg:Select(tp,1,1,nil)
			if #hg>0 then
				Duel.SendtoHand(hg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,hg)
			end
		end
	end
end
function s.getsearchgroup(c,e,tp,eg,ep,ev,re,r,rp)
	cregister=Card.RegisterEffect
	cisfaceup=Card.IsFaceup
	cisabletohand=Card.IsAbleToHand
	cisabletohandascost=Card.IsAbleToHandAsCost
	disexistingiarget=Duel.IsExistingTarget
	disexistingmatchingcard=Duel.IsExistingMatchingCard
	local search_effect=false
	local search_record={}
	local sg=Group.CreateGroup()
	Card.IsFaceup=function(card)
		return true
	end
	Card.IsAbleToHand=function(card)
		search_effect=true
		return cisabletohand(card)
	end
	Card.IsAbleToHandAsCost=function(card)
		search_effect=true
		return cisabletohandascost(card)
	end
	Card.RegisterEffect=function(card,effect,flag)
		if effect and effect:GetType()~=EFFECT_TYPE_FIELD then
			search_effect=false
			local cost=effect:GetCost()
			local tg=effect:GetTarget()
			if cost and cost(e,tp,eg,ep,ev,re,r,rp,0) then end
			if tg and tg(e,tp,eg,ep,ev,re,r,rp,0) then end
		end
		return 
	end
	Duel.IsExistingMatchingCard=function(filter,player,s,o,count,c_g_n,...)
		if s==LOCATION_MZONE then
			s=LOCATION_DECK 
		end
		if disexistingmatchingcard(filter,player,s,o,count,c_g_n,...) and search_effect then
			local g=Duel.GetMatchingGroup(filter,player,s,o,c_g_n,...)
			sg:Merge(g)
		end
		return disexistingmatchingcard(filter,player,s,o,count,c_g_n,...)
	end
	Duel.IsExistingTarget=function(filter,player,s,o,count,c_g_n,...)
		if s==LOCATION_MZONE then
			s=LOCATION_DECK 
		end
		if disexistingmatchingcard(filter,player,s,o,count,c_g_n,...) and search_effect then
			local g=Duel.GetMatchingGroup(filter,player,s,o,c_g_n,...)
			sg:Merge(g)
		end
		return disexistingmatchingcard(filter,player,s,o,count,c_g_n,...)
	end
	table_effect={}
	Duel.CreateToken(0,c:GetOriginalCode())
	Card.RegisterEffect=cregister
	Card.IsFaceup=cisfaceup
	Card.IsAbleToHand=cisabletohand
	Card.IsAbleToHandAsCost=cisabletohandascost
	Duel.IsExistingTarget=disexistingiarget
	Duel.IsExistingMatchingCard=disexistingmatchingcard
	return sg
end
