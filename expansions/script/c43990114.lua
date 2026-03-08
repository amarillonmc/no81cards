--黑兽-未
local m=43990114
local cm=_G["c"..m]
function cm.initial_effect(c)
	--defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Removerm
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43990114,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,43990114)
	e2:SetCondition(c43990114.rmcon)
	e2:SetTarget(c43990114.rmtg)
	e2:SetOperation(c43990114.rmop1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c43990114.rmop2)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(43990114,1))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,43900114)
	e4:SetCondition(c43990114.spcon)
	e4:SetTarget(c43990114.sptg)
	e4:SetOperation(c43990114.spop)
	c:RegisterEffect(e4)
	
end
function c43990114.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==1-tp
end
function c43990114.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsDefensePos()
end

function c43990114.thfilter(c)
	return c:IsSetCard(0x6510) and c:IsAbleToHand() and not c:IsCode(43990114)
end
function c43990114.gcheck(g)
	return g:GetClassCount(Card.GetControler)==#g
end
function c43990114.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if chk==0 then return c:IsAbleToRemove() and g:CheckSubGroup(c43990114.gcheck,2,2) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,0,0)
end
function c43990114.rmop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:CheckSubGroup(c43990114.gcheck,2,2) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:SelectSubGroup(tp,c43990114.gcheck,false,2,2)
		if #sg~=2 or Duel.Remove(sg,0,REASON_EFFECT+REASON_TEMPORARY)==0 or not sg:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) then return end
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		local fid=c:GetFieldID()
		for tc in aux.Next(og) do
			tc:RegisterFlagEffect(43990114,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabel(fid)
		e1:SetLabelObject(og)
		e1:SetCountLimit(1)
		e1:SetCondition(c43990114.retcon)
		e1:SetOperation(c43990114.retop2)
		Duel.RegisterEffect(e1,tp)
	end
end
function c43990114.rmop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 and c:GetOriginalCode()==43990114 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c43990114.retop1)
		Duel.RegisterEffect(e1,tp)
	end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:CheckSubGroup(c43990114.gcheck,2,2) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:SelectSubGroup(tp,c43990114.gcheck,false,2,2)
		if #sg~=2 or Duel.Remove(sg,0,REASON_EFFECT+REASON_TEMPORARY)==0 or not sg:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) then return end
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		local fid=c:GetFieldID()
		for tc in aux.Next(og) do
			tc:RegisterFlagEffect(43990114,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabel(fid)
		e1:SetLabelObject(og)
		e1:SetCountLimit(1)
		e1:SetCondition(c43990114.retcon)
		e1:SetOperation(c43990114.retop2)
		Duel.RegisterEffect(e1,tp)
	end
end
function c43990114.retop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c43990114.retfilter(c,fid)
	return c:GetFlagEffectLabel(43990114)==fid
end
function c43990114.retcon(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetLabelObject():IsExists(c43990114.retfilter,1,nil,e:GetLabel()) then
		e:GetLabelObject():DeleteGroup()
		e:Reset()
		return false
	end
	return true
end
function c43990114.retop2(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	local g=e:GetLabelObject():Filter(c43990114.retfilter,nil,fid)
	if #g<=0 then return end
	Duel.Hint(HINT_CARD,0,43990114)
	for p in aux.TurnPlayers() do
		local tg=g:Filter(Card.IsPreviousControler,nil,p)
		local ft=Duel.GetLocationCount(p,LOCATION_MZONE)
		if #tg>1 and ft==1 then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOFIELD)
			local sg=tg:Select(p,1,1,nil)
			Duel.ReturnToField(sg:GetFirst())
			tg:Sub(sg)
		end
		for tc in aux.Next(tg) do
			Duel.ReturnToField(tc)
		end
	end
	e:GetLabelObject():DeleteGroup()
end
function c43990114.spfilter(c,e,tp)
	return c:IsSetCard(0x6510) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c43990114.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c43990114.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c43990114.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c43990114.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end