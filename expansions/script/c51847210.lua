--辉光序曲"哨戒"-「六芒星」
function c51847210.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_MACHINE),2)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa68))
	c:RegisterEffect(e1)
	--position
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetDescription(aux.Stringid(51847210,0))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_MSET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,51847210)
	e2:SetCost(c51847210.poscost)
	e2:SetTarget(c51847210.postg)
	e2:SetOperation(c51847210.posop)
	c:RegisterEffect(e2)
end
function c51847210.rmfilter(c,ec,tp)
	local g=Group.FromCards(c,ec)
	return c:IsSetCard(0xa68) and c:IsFaceup() and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c51847210.posfilter,tp,0,LOCATION_MZONE,1,nil,g)
end
function c51847210.posfilter(c,g)
	local lg=c:GetColumnGroup():Filter(Card.IsFaceup,nil)
	return c:IsFaceup() and c:IsCanTurnSet() and lg:IsExists(Card.IsSetCard,1,g,0xa68)
end
function c51847210.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c51847210.rmfilter,tp,LOCATION_MZONE,0,1,c,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c51847210.rmfilter,tp,LOCATION_MZONE,0,1,1,c):GetFirst()
	local g=Group.FromCards(c,tc):Filter(Card.IsType,nil,TYPE_LINK)
	local sel=#g>0 and Duel.IsPlayerAffectedByEffect(tp,51847220) and Duel.SelectYesNo(tp,aux.Stringid(51847220,0)) and 1 or 0
	local fid=c:GetFieldID()
	e:SetLabel(sel,fid)
	Duel.Remove(Group.FromCards(c,tc),POS_FACEUP,REASON_COST+REASON_TEMPORARY)
	local og=Duel.GetOperatedGroup()
	for oc in aux.Next(og) do
		local des=sel==1 and g:IsContains(oc) and aux.Stringid(51847220,2) or aux.Stringid(51847210,2)
		oc:RegisterFlagEffect(51847210,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,des)
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
	e1:SetCondition(c51847210.retcon)
	e1:SetOperation(c51847210.retop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c51847210.retfilter(c,fid)
	return c:GetFlagEffectLabel(51847210)==fid
end
function c51847210.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c51847210.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c51847210.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c51847210.retfilter,nil,e:GetLabel())
	g:DeleteGroup()
	for tc in aux.Next(sg) do
		Duel.ReturnToField(tc)
	end
end
function c51847210.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c51847210.posfilter,tp,0,LOCATION_MZONE,nil,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c51847210.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local _,fid=e:GetLabel()
	for tc in aux.Next(g) do
		if tc:GetFlagEffectLabel(51847220)==fid then tc:ResetFlagEffect(51847220) Duel.ReturnToField(tc) end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local tg=Duel.SelectMatchingCard(tp,c51847210.posfilter,tp,0,LOCATION_MZONE,1,3,nil)
	if #tg>0 then
		Duel.HintSelection(tg)
		Duel.ChangePosition(tg,POS_FACEDOWN_DEFENSE)
	end
end
