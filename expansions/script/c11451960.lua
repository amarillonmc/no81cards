--晚上处刑II
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SSET)
	e2:SetLabelObject(e1)
	e2:SetOperation(cm.setop)
	Duel.RegisterEffect(e2,0)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not eg:IsContains(c) then return end
	local fid=c:GetRealFieldID()
	local te=e:GetLabelObject()
	te:SetLabel(fid)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1,fid)
	end
end
function cm.desfilter(c,fid)
	return c:GetFlagEffectLabel(m) and c:GetFlagEffectLabel(m)==fid
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,e:GetLabel())
	if chk==0 then return g:GetCount()>0 end
	Duel.SetTargetCard(g)
	Duel.HintSelection(g)
	e:SetLabel(0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetValue(Duel.GetCurrentChain())
		e1:SetOperation(cm.negop)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_CHAIN_NEGATED)
		e2:SetOperation(cm.negop2)
		e2:SetReset(RESET_CHAIN)
		e2:SetLabelObject(e1)
		Duel.RegisterEffect(e2,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then
		if ev~=e:GetValue() then e:SetLabel(ev) end
	elseif e:GetLabel()==ev+1 then 
		Duel.Hint(HINT_CARD,0,m)
		Duel.NegateEffect(ev)
		e:SetLabel(0)
	else
		e:SetLabel(0)
	end
end
function cm.negop2(e,tp,eg,ep,ev,re,r,rp)
	if ev==e:GetValue() then
		e:GetLabelObject():Reset()
	end
end