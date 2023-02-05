local m=53796098
local cm=_G["c"..m]
cm.name="虚拟YouTuber 艾琳"
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetLabelObject(e1)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.AnnounceCard(tp,TYPE_SYNCHRO+TYPE_XYZ,OPCODE_ISTYPE)
	e:SetLabel(ac)
	e:GetHandler():SetHint(CHINT_CARD,ac)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spfilter(c,code)
	return c:IsCode(code) and (c:IsSynchroSummonable(nil) or c:IsXyzSummonable(nil))
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_EXTRA,0,nil,e:GetLabelObject():GetLabel())
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0xff0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(cm.efilter)
		e2:SetOwnerPlayer(tp)
		tc:RegisterEffect(e2)
		local op,res1,res2=0,tc:IsSynchroSummonable(nil),tc:IsXyzSummonable(nil)
		if res1 and res2 then op=Duel.SelectOption(tp,1164,1165) elseif res1 then op=0 else op=1 end
		if op==0 then Duel.SynchroSummon(tp,tc,nil) else Duel.XyzSummon(tp,tc,nil) end
	else Duel.Damage(tp,2000,REASON_EFFECT) end
end
function cm.efilter(e,te)
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer()
end
