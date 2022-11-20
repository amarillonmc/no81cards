--连锁的落穴
function c10174020.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c10174020.activate)
	c:RegisterEffect(e1)
end
function c10174020.activate(e,tp,eg)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_OPPO_TURN)
	e1:SetCondition(c10174020.cfcon)
	e1:SetOperation(c10174020.cfop)
	Duel.RegisterEffect(e1,tp)
	e1:SetLabel(tp)
end
function c10174020.cfcon(e)
	return Duel.GetTurnPlayer()~=e:GetLabel()
end
function c10174020.cfop(e)
	local tp,c=e:GetLabel(),e:GetHandler()
	Duel.Hint(HINT_CARD,0,10174020)
	if Duel.Draw(tp,2,REASON_EFFECT)<=0 then return end
	local g=Duel.GetOperatedGroup()
	local fid=c:GetFieldID()
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(10174020,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	g:KeepAlive()
	e2:SetLabelObject(g)
	e2:SetLabel(fid)
	e2:SetCondition(c10174020.tdcon)
	e2:SetOperation(c10174020.tdop)
	Duel.RegisterEffect(e2,tp)
end
function c10174020.cfilter(c,fid)
	return c:GetFlagEffectLabel(10174020)==fid
end
function c10174020.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c10174020.cfilter,nil,e:GetLabel())
	if #tg>0 then return true
	else
		g:DeleteGroup()
		e:Reset()
	return false
	end
end
function c10174020.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10174020)
	local g=e:GetLabelObject()
	local tg=g:Filter(c10174020.cfilter,nil,e:GetLabel())
	Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
end