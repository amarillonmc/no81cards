--隐花稻荷
--23.06.28
local cm,m=GetID()
function cm.initial_effect(c)
	--banish
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost(POS_FACEDOWN) end
	Duel.Remove(e:GetHandler(),POS_FACEDOWN,REASON_COST)
end
function cm.filter(c,code)
	return c:IsAbleToRemove(POS_FACEDOWN) and c:IsCode(code)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil,tp,POS_FACEDOWN) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,1-tp,LOCATION_DECK,0,1,nil,1-tp,POS_FACEDOWN) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,LOCATION_DECK,nil,ac)
	if #g>0 and Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		og:ForEach(Card.RegisterFlagEffect,m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
		og:KeepAlive()
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetDescription(aux.Stringid(m,1))
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_PHASE+PHASE_END)
		e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e0:SetLabelObject(og)
		e0:SetCountLimit(1)
		e0:SetCondition(cm.retcon)
		e0:SetOperation(cm.retop)
		Duel.RegisterEffect(e0,tp)
	end
end
function cm.filter6(c)
	return c:GetFlagEffect(m)>0
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(cm.filter6,1,nil) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g then return end
	local sg=g:Filter(cm.filter6,nil)
	if e:GetLabel()==0 then
		sg=sg:Filter(Card.IsAbleToDeck,nil)
		local tg=sg:FilterSelect(tp,Card.IsControler,1,1,nil,tp)
		local tg2=sg:FilterSelect(1-tp,Card.IsControler,1,1,nil,1-tp)
		tg:Merge(tg2)
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
		e:SetLabel(e:GetLabel()+1)
	elseif e:GetLabel()==1 then
		local tg=sg:FilterSelect(tp,Card.IsControler,1,1,nil,tp)
		local tg2=sg:FilterSelect(1-tp,Card.IsControler,1,1,nil,1-tp)
		tg:Merge(tg2)
		Duel.SendtoGrave(tg,REASON_EFFECT+REASON_RETURN)
		e:SetLabel(e:GetLabel()+1)
	elseif e:GetLabel()>=2 then
		sg=sg:Filter(Card.IsAbleToHand,nil)
		local tg=sg:FilterSelect(tp,Card.IsControler,1,1,nil,tp)
		local tg2=sg:FilterSelect(1-tp,Card.IsControler,1,1,nil,1-tp)
		tg:Merge(tg2)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end