--甜蜜斥候
function c33700153.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetDescription(aux.Stringid(33700153,0))
	e1:SetCode(EVENT_DRAW)
	e1:SetCountLimit(1)
	e1:SetCondition(c33700153.condition)
	e1:SetTarget(c33700153.target)
	e1:SetOperation(c33700153.activate)
	c:RegisterEffect(e1)
end
function c33700153.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and r~=REASON_RULE
end
function c33700153.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsAbleToRemove() end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c33700153.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.IsChainDisablable(0)  and Duel.SelectYesNo(1-tp,aux.Stringid(33700153,1)) then
	Duel.Recover(tp,1000,REASON_EFFECT)
	Duel.NegateEffect(0)
	else
	if g:GetCount()~=0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local fid=e:GetHandler():GetFieldID()
		local og=Duel.GetOperatedGroup()
		local oc=og:GetFirst()
		while oc do
			oc:RegisterFlagEffect(33700153,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
			oc=og:GetNext()
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)	 
		e1:SetLabel(fid)
		e1:SetLabelObject(og)
		e1:SetCondition(c33700153.retcon)
		e1:SetOperation(c33700153.retop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
end
end
end
function c33700153.retfilter(c,fid)
	return c:GetFlagEffectLabel(33700153)==fid
end
function c33700153.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c33700153.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c33700153.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c33700153.retfilter,nil,e:GetLabel())
	g:DeleteGroup()
	local tc=sg:GetFirst()
	while tc do
		Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
		tc=sg:GetNext()
	end
end