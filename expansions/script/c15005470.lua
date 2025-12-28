local m=15005470
local cm=_G["c"..m]
cm.name="『欢愉』的愚者-花火"
function cm.initial_effect(c)
	--public
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--while public
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.chaincon)
	e1:SetOperation(cm.chainop)
	c:RegisterEffect(e1)
end
function cm.quick_filter(e)
	return (e:GetCode()==EVENT_CHAINING or e:GetCode()==EVENT_BECOME_TARGET) and e:IsHasType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_QUICK_F) and e:IsHasRange(LOCATION_HAND)
end
function cm.cfilter(c)
	return c:IsOriginalEffectProperty(cm.quick_filter) and c:IsType(TYPE_MONSTER)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cc=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	Duel.ConfirmCards(1-tp,cc)
	Duel.ShuffleDeck(tp)
	e:SetLabelObject(cc)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local fid=c:GetFieldID()
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,66)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_PUBLIC)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e0)
	--summon limit
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	e3:SetLabel(fid)
	e3:SetLabelObject(c)
	e3:SetCondition(cm.indcon)
	c:RegisterEffect(e3)
	--spsummon limit
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.FALSE)
	e2:SetLabel(fid)
	e2:SetLabelObject(c)
	e2:SetCondition(cm.indcon)
	c:RegisterEffect(e2)
	if not e:GetLabelObject() then return end
	local sc=e:GetLabelObject()
	local code=sc:GetOriginalCode()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(code)
	e1:SetLabel(fid)
	e1:SetLabelObject(c)
	e1:SetCondition(cm.indcon)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
end
function cm.indcon(e)
	local c=e:GetLabelObject()
	return c:GetFlagEffectLabel(m)==e:GetLabel()
end
function cm.chaincon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsPublic()
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	local roll=Duel.TossDice(tp,1)
	if roll==5 or roll==6 then
		Duel.SetChainLimit(cm.chainlm(e:GetHandler()))
	end
end
function cm.chainlm(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end