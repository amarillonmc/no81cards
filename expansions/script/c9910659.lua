--拉尼亚凯亚之旅人
function c9910659.initial_effect(c)
	--special summon rule(on self field)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910659,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c9910659.sprcon)
	e1:SetOperation(c9910659.sprop)
	c:RegisterEffect(e1)
	--special summon rule(on oppent field)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910659,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetTargetRange(POS_FACEUP,1)
	e2:SetCondition(c9910659.sprcon2)
	e2:SetOperation(c9910659.sprop2)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,9910659)
	e3:SetOperation(c9910659.drop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--remove
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_BECOME_TARGET)
	e5:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e5:SetCountLimit(1,9910660)
	e5:SetCondition(c9910659.rmcon)
	e5:SetTarget(c9910659.rmtg)
	e5:SetOperation(c9910659.rmop)
	c:RegisterEffect(e5)
end
function c9910659.sprfilter(c,tp,sp)
	return (c:IsAttackAbove(3000) or c:IsDefenseAbove(3000)) and c:IsAbleToRemoveAsCost() and c:IsFaceup()
		and Duel.GetMZoneCount(tp,c,sp)>0
end
function c9910659.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c9910659.sprfilter,tp,LOCATION_MZONE,0,1,nil,tp,tp)
end
function c9910659.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9910659.sprfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9910659.sprcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c9910659.sprfilter,tp,0,LOCATION_MZONE,1,nil,1-tp,tp)
end
function c9910659.sprop2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9910659.sprfilter,tp,0,LOCATION_MZONE,1,1,nil,1-tp,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9910659.xyzfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and not c:IsImmuneToEffect(e)
end
function c9910659.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetOwner()
	if not Duel.IsPlayerCanDraw(p) then return end
	local dt=Duel.GetFieldGroupCount(p,LOCATION_DECK,0)
	local xg=Duel.GetMatchingGroup(c9910659.xyzfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e,tp)
	local ct=0
	local min=1
	while #xg>0 and ct<dt do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
		local sg=xg:Select(tp,min,1,nil)
		if #sg==0 then break end
		ct=sg:GetFirst():RemoveOverlayCard(tp,1,1,REASON_COST)+ct
		xg:Sub(sg)
		min=0
	end
	if ct>0 then Duel.Draw(p,ct,REASON_EFFECT) end
end
function c9910659.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c9910659.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g>0 then
		g:AddCard(c)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
	end
end
function c9910659.ogfilter(c)
	return c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT)
end
function c9910659.rmop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Group.CreateGroup()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then rg:AddCard(c) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e))
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		rg:Merge(sg)
	end
	if Duel.Remove(rg,0,REASON_EFFECT+REASON_TEMPORARY)>0 then
		local og=Duel.GetOperatedGroup():Filter(c9910659.ogfilter,nil)
		if #og==0 then return end
		local fid=c:GetFieldID()
		for tc in aux.Next(og) do
			tc:RegisterFlagEffect(9910659,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabel(fid)
		e1:SetLabelObject(og)
		e1:SetCountLimit(1)
		e1:SetCondition(c9910659.retcon)
		e1:SetOperation(c9910659.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9910659.retfilter(c,fid)
	return c:GetFlagEffectLabel(9910659)==fid
end
function c9910659.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c9910659.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c9910659.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(c9910659.retfilter,nil,e:GetLabel())
	for tc in aux.Next(g) do
		local loc=tc:GetPreviousLocation()
		if loc==LOCATION_MZONE then
			Duel.ReturnToField(tc)
		end
		if loc==LOCATION_GRAVE then
			Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
		end
	end
end
