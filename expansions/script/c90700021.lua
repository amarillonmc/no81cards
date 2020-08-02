local m=90700021
local cm=_G["c"..m]
cm.name="魔轰神兽 别西卜"
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x35),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local egain=Effect.CreateEffect(c)
	egain:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	egain:SetCode(EVENT_ADJUST)
	egain:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	egain:SetRange(LOCATION_EXTRA)
	egain:SetOperation(cm.egainop)
	egain:SetCountLimit(1,EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(egain)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetCode(90700021)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(1,0)
	c:RegisterEffect(e0)
	if c90700021.counter==nil then
		c90700021.counter=true
		c90700021[0]=0
		c90700021[1]=0
		local edraw=Effect.CreateEffect(c)
		edraw:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		edraw:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		edraw:SetCode(EVENT_CHAIN_SOLVING)
		edraw:SetOperation(cm.edrawop)
		local edraw0=Effect.Clone(edraw)
		edraw0:SetLabel(0)
		Duel.RegisterEffect(edraw0,0)
		local edraw1=Effect.Clone(edraw)
		edraw1:SetLabel(1)
		Duel.RegisterEffect(edraw1,1)
		local ere=Effect.CreateEffect(c)
		ere:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ere:SetCode(EVENT_CHAIN_SOLVED)
		ere:SetOperation(cm.ereop)
		local ere0=Effect.Clone(ere)
		ere0:SetLabel(0)
		Duel.RegisterEffect(ere0,0)
		local ere1=Effect.Clone(ere)
		ere1:SetLabel(1)
		Duel.RegisterEffect(ere1,1)
	end
end
function cm.egainop(e,tp,eg,ep,ev,re,r,rp)
	local g
	if Duel.GetFieldGroupCount(Card.IsCode,0,LOCATION_EXTRA,nil,90700021)>0 then
		g=Duel.GetMatchingGroup(nil,tp,0x1ff,0,nil)
	else
		g=Duel.GetMatchingGroup(nil,tp,0x1ff,0x1ff,nil)
	end
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetRange(LOCATION_HAND)
		e1:SetCondition(cm.egcon)
		e1:SetDescription(aux.Stringid(90700021,0))
		e1:SetCost(cm.egcost)
		e1:SetOperation(cm.egop)
		tc:RegisterEffect(e1,true)
		tc=g:GetNext()
	end
end
function cm.egcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsSetCard(0x35) and e:GetHandler():IsType(TYPE_MONSTER) and Duel.IsPlayerAffectedByEffect(tp,90700021)
end
function cm.egcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable(REASON_COST) end
	e:SetLabel(e:GetHandler():GetControler())
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.egop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabel()
	c90700021[p]=c90700021[p]+1
end
function cm.edrawop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetLabel()
	if Duel.GetFlagEffect(tp,m)>0 then return end
	Duel.RegisterFlagEffect(tp,m,RESET_EVENT+RESET_CHAIN,0,1)
	if ep==tp or not Duel.IsPlayerCanDraw(tp) or c90700021[tp]==0 then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(90700021,1)) then return end
	local dmax=c90700021[tp]
	local decknum=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if decknum<dmax then
		dmax=decknum
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(90700021,2))
	local opt={}
	for i=1,dmax do
		opt[i]=i
	end
	opt[dmax+1]=nil
	local drawnum=Duel.AnnounceNumber(tp,table.unpack(opt))
	Duel.Draw(tp,drawnum,REASON_EFFECT)
	c90700021[tp]=c90700021[tp]-drawnum
end
function cm.ereop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(e:GetLabel(),m)
end