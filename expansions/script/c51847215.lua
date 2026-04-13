--辉光序曲"引导"-「天狼星」
function c51847215.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_MACHINE),2)
	--double damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa68))
	e1:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetDescription(aux.Stringid(51847215,3))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,51847215)
	e2:SetCost(c51847215.drcost)
	e2:SetTarget(c51847215.drtg)
	e2:SetOperation(c51847215.drop)
	c:RegisterEffect(e2)
end
function c51847215.rmfilter(c)
	return c:IsSetCard(0xa68) and c:IsAbleToRemoveAsCost()
end
function c51847215.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c51847215.rmfilter,tp,LOCATION_DECK,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c51847215.rmfilter,tp,LOCATION_DECK,0,1,1,c):GetFirst()
	local g=Group.FromCards(c,tc):Filter(Card.IsType,nil,TYPE_LINK)
	local sel=#g>0 and Duel.IsPlayerAffectedByEffect(tp,51847220) and Duel.SelectYesNo(tp,aux.Stringid(51847220,0)) and 1 or 0
	local fid=c:GetFieldID()
	e:SetLabel(sel,fid)
	Duel.Remove(Group.FromCards(c,tc),POS_FACEUP,REASON_COST+REASON_TEMPORARY)
	local og=Duel.GetOperatedGroup()
	for oc in aux.Next(og) do
		local des=oc:IsPreviousLocation(LOCATION_MZONE) and aux.Stringid(51847215,2) or aux.Stringid(51847215,1)
		if sel==1 and g:IsContains(oc) then des=aux.Stringid(51847220,2) end
		oc:RegisterFlagEffect(51847215,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,des)
	end
	if sel==1 then c:RegisterFlagEffect(51847220,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid) end
	og:KeepAlive()
	e:SetLabelObject(og)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(og)
	e1:SetCondition(c51847215.retcon)
	e1:SetOperation(c51847215.retop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c51847215.retfilter(c,fid)
	return c:GetFlagEffectLabel(51847215)==fid
end
function c51847215.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c51847215.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c51847215.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c51847215.retfilter,nil,e:GetLabel())
	g:DeleteGroup()
	for tc in aux.Next(sg) do
		if tc~=e:GetHandler() then Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		else Duel.ReturnToField(tc) end
	end
end
function c51847215.acfilter(c,tp)
	return c:IsCode(51847220) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c51847215.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c51847215.acfilter,tp,LOCATION_DECK,0,1,nil,tp)
	local b2=Duel.IsExistingMatchingCard(nil,tp,LOCATION_FZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1)
	if chk==0 then return b1 or b2 end
end
function c51847215.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local _,fid=e:GetLabel()
	for tc in aux.Next(g) do
		if tc:GetFlagEffectLabel(51847220)==fid then tc:ResetFlagEffect(51847220) Duel.ReturnToField(tc) end
	end
	local b1=Duel.IsExistingMatchingCard(c51847215.acfilter,tp,LOCATION_DECK,0,1,nil,tp)
	local b2=Duel.IsExistingMatchingCard(nil,tp,LOCATION_FZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1)
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(51847215,0))) then
		Duel.Draw(tp,1,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=Duel.SelectMatchingCard(tp,c51847215.acfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		local te=tc:GetActivateEffect()
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
