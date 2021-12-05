local m=53705023
local cm=_G["c"..m]
cm.name="旧幻海袭 舱人"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:SetSPSummonOnce(m)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.drcon)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(SUMMON_TYPE_SYNCHRO+SUMMON_VALUE_SELF)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(cm.thcon)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
end
function cm.cfilter1(c)
	return c:IsSetCard(0x3534) and c:IsType(TYPE_MONSTER) and c:IsPublic() and c:IsAbleToDeckAsCost()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_HAND,0,1,c,tp) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter1,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	e:GetHandler():SetMaterial(g)
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.drop(e,tp,eg)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.cfcon)
	e1:SetOperation(cm.cfop)
	Duel.RegisterEffect(e1,tp)
	e1:SetLabel(tp)
end
function cm.cfcon(e)
	return Duel.GetTurnPlayer()~=e:GetLabel()
end
function cm.drfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3534)
end
function cm.cfop(e)
	local tp,c=e:GetLabel(),e:GetHandler()
	Duel.Hint(HINT_CARD,0,m)
	local ct=Duel.GetMatchingGroupCount(cm.drfilter,tp,LOCATION_MZONE,0,nil)
	if Duel.Draw(tp,ct,REASON_EFFECT)<=0 then return end
	local g=Duel.GetOperatedGroup()
	local fid=c:GetFieldID()
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(53702500,3))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
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
	e2:SetCondition(cm.tdcon)
	e2:SetOperation(cm.tdop)
	Duel.RegisterEffect(e2,tp)
end
function cm.cfilter(c,fid)
	return c:GetFlagEffectLabel(m)==fid
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(cm.cfilter,nil,e:GetLabel())
	if #tg>0 then return true
	else
		g:DeleteGroup()
		e:Reset()
	return false
	end
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local g=e:GetLabelObject()
	local tg=g:Filter(cm.cfilter,nil,e:GetLabel())
	Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetSummonType()==SUMMON_TYPE_SYNCHRO+SUMMON_VALUE_SELF 
end
function cm.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local code=e:GetHandler():GetMaterial():GetFirst():GetCode()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,code) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetHandler():GetMaterial():GetFirst():GetCode()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,code)
	if hg:GetCount()>0 then
		Duel.SendtoHand(hg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,hg)
	end
end
