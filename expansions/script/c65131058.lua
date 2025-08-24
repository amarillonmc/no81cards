--救世之章 强令
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMINGS_CHECK_MONSTER+TIMING_DAMAGE_STEP)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
end
function s.chainfilter(re,tp,cid)
	return not (re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_QUICKPLAY) and re:GetHandler():IsSetCard(0x837))
end
function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER) and c:IsSetCard(0x837)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(0)
	if chk==0 then return true end  
	local ct=Duel.GetTargetCount(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if ct>1 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) then
		local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
		local sg=g:CancelableSelect(tp,1,ct-1,nil)
		if sg then
			e:SetLabel(sg:GetCount())
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_QUICKPLAY) and re:GetHandler():IsSetCard(0x837)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1+ct,nil)
end
function s.spfilter(c,tg)
	return c:IsSynchroSummonable(nil,tg,#tg-1,#tg-1) or c:IsXyzSummonable(tg,#tg,#tg) or c:IsLinkSummonable(tg,nil,#tg,#tg)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local b3=tg:FilterCount(Card.IsCanTurnSet,nil)==tg:GetCount()
	local op=aux.SelectFromOptions(tp,
			{true,aux.Stringid(id,1)},
			{true,aux.Stringid(id,2)},
			{b3,aux.Stringid(id,3)})
	if op==1 then
		for tc in aux.Next(tg) do		 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_TRIGGER)
			tc:RegisterEffect(e2,true)
		end
	elseif op==2 then
		local sg=Duel.GetMatchingGroup(s.spfilter,tp,0,LOCATION_EXTRA,nil,tg)
		if sg:GetCount()>0 then
			local sc=sg:Select(1-tp,1,1,nil):GetFirst()
			local op2=aux.SelectFromOptions(1-tp,
			{sc:IsSynchroSummonable(nil,tg,#tg-1,#tg-1),1164},
			{sc:IsXyzSummonable(tg,#tg,#tg),1165},
			{sc:IsLinkSummonable(tg,nil,#tg,#tg),1166})
			if op2==1 then
				Duel.SynchroSummon(1-tp,sc,nil,tg,#tg-1,#tg-1)
			elseif op2==2 then
				Duel.XyzSummon(1-tp,sc,tg,#tg,#tg)
			elseif op2==3 then
				Duel.LinkSummon(1-tp,sc,tg,nil,#tg,#tg)
			end
		end
	elseif op==3 then
		Duel.ChangePosition(tg,POS_FACEDOWN_DEFENSE)
	end 
end