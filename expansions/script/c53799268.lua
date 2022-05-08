local m=53799268
local cm=_G["c"..m]
cm.name="期待"
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 end)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_EXTRA,LOCATION_EXTRA)
	e1:SetCost(cm.costchk)
	e1:SetOperation(cm.costop)
	c:RegisterEffect(e1)
end
function cm.costchk(e,te_or_c,tp)
	e:SetLabelObject(te_or_c)
	return true
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc:IsFaceup() then return end
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(c).announce_filter={TYPE_MONSTER,OPCODE_ISTYPE,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_AND}
	local ac=Duel.AnnounceCard(1-tc:GetSummonPlayer(),table.unpack(getmetatable(c).announce_filter))
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetLabel(ac)
	e2:SetLabelObject(tc)
	e2:SetOperation(cm.op)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_NEGATED)
	e3:SetLabelObject(e2)
	e3:SetOperation(cm.rstop)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CUSTOM+m)
	e4:SetLabelObject(e3)
	e4:SetOperation(cm.rstop)
	Duel.RegisterEffect(e4,tp)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local code,tc=e:GetLabel(),e:GetLabelObject()
	if tc:IsOriginalCodeRule(code) then Duel.SendtoGrave(tc,REASON_RULE) else
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetDescription(aux.Stringid(m,0))
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e3:SetRange(LOCATION_MZONE)
		e3:SetValue(function(e,re)return e:GetOwnerPlayer()~=re:GetOwnerPlayer()end)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetOwnerPlayer(tp)
		tc:RegisterEffect(e3)
	end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+53728000,re,r,rp,ep,ev)
	e:Reset()
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject() then e:GetLabelObject():Reset() end
	e:Reset()
end
