--龙启之地的嗜睡羔羊
local m=23003016
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,cm.sfilter,aux.NonTuner(cm.sfilter),1)
	c:EnableReviveLimit()
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.sfilter(c)
	return c:IsSetCard(0x352) 
end

function cm.spcostfilter(c)
	return c:IsAbleToDeckAsCost() and c:IsSetCard(0x352)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.spcostfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
	if sg:GetFirst():IsType(TYPE_NORMAL) then
		e:SetLabel(1)
	end
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0x352) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsType(TYPE_MONSTER)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(cm.val3)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		if e:GetLabel()==1 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(1200)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end
	end
	e:SetLabel(0)
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
end
function cm.val3(e,re)
	return not re:GetOwner()==e:GetOwner()
end