local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,id-4)
	--set and destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER|TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.setcon)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.chcon)
	e2:SetOperation(s.chop)
	c:RegisterEffect(e2)
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function s.setfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local turn_p=Duel.GetTurnPlayer()
	if chk==0 then
		if turn_p==tp then
			return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
				and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_HAND,0,1,nil)
		else
			return Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
				and Duel.IsPlayerCanSSet(1-tp)
		end
	end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local turn_p=Duel.GetTurnPlayer()
	if Duel.GetLocationCount(turn_p,LOCATION_SZONE)<=0 then return end
	local tc=nil
	if turn_p==tp then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_HAND,0,1,1,nil)
		tc=g:GetFirst()
	else
		local g=Duel.GetMatchingGroup(s.setfilter,1-tp,LOCATION_HAND,0,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
			local sg=g:Select(1-tp,1,1,nil)
			tc=sg:GetFirst()
		end
	end
	if tc and Duel.SSet(turn_p,tc)~=0 then
		local opp=1-turn_p
		if Duel.GetLocationCount(opp,LOCATION_SZONE)>0 and Duel.IsPlayerCanSSet(opp) then
			local hg=Duel.GetMatchingGroup(s.setfilter,opp,LOCATION_DECK,0,nil)
			if hg:GetCount()>0 and Duel.SelectYesNo(opp,aux.Stringid(id,1)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,opp,HINTMSG_SET)
				local htc=hg:Select(opp,1,1,nil):GetFirst()
				if htc and Duel.SSet(opp,htc)~=0 then
					local dg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
					if dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
						local dgc=dg:Select(tp,1,1,nil)
						Duel.HintSelection(dgc)
						Duel.Destroy(dgc,REASON_EFFECT)
					end
				end
			end
		end
	end
end
function s.repfilter(c)
	return c:IsFacedown() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler()~=c
		and Duel.IsExistingMatchingCard(s.repfilter,ep,LOCATION_SZONE,0,1,nil)
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.repop)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.repfilter,tp,LOCATION_SZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_REMOVED) then
		local is_main = Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
		local is_normal = tc:GetType()==TYPE_SPELL or tc:GetType()==TYPE_TRAP
		if is_main and is_normal then
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			if te then
				local condition=te:GetCondition()
				local cost=te:GetCost()
				local target=te:GetTarget()
				local operation=te:GetOperation()
				if (not condition or condition(te,tep,eg,ep,ev,re,r,rp))
					and (not cost or cost(te,tep,eg,ep,ev,re,r,rp,0))
					and (not target or target(te,tep,eg,ep,ev,re,r,rp,0)) then
					Duel.ClearTargetCard()
					e:SetProperty(te:GetProperty())
					tc:CreateEffectRelation(te)
					if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
					if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
					local tg_g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
					local tg=nil
					if tg_g then tg=tg_g:GetFirst() end
					while tg do
						tg:CreateEffectRelation(te)
						tg=tg_g:GetNext()
					end
					if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
					tc:ReleaseEffectRelation(te)
					if tg_g then
						tg=tg_g:GetFirst()
						while tg do
							tg:ReleaseEffectRelation(te)
							tg=tg_g:GetNext()
						end
					end
				end
			end
		end
	end
end