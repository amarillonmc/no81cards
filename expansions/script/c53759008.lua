local m=53759008
local cm=_G["c"..m]
cm.name="魔导心术-「疲」"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x41) and c:GetActivateEffect()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1)
		local ct=tc:GetFlagEffect(m)
		local le={tc:GetActivateEffect()}
		for i,v in pairs(le) do
			local e1=Effect.CreateEffect(e:GetHandler())
			if #le==1 then e1:SetDescription(aux.Stringid(m,0)) else e1:SetDescription(v:GetDescription()) end
			e1:SetCategory(v:GetCategory())
			if v:GetCode()==EVENT_FREE_CHAIN or (v:GetCode()==EVENT_CHAINING and v:GetProperty()&EFFECT_FLAG_DELAY==0) then
				e1:SetType(EFFECT_TYPE_QUICK_O)
			else
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
			end
			e1:SetCode(v:GetCode())
			e1:SetRange(LOCATION_MZONE)
			e1:SetProperty(v:GetProperty())
			e1:SetCountLimit(1)
			e1:SetCost(cm.spellcost)
			e1:SetTarget(cm.spelltg(i,ct))
			e1:SetOperation(cm.spellop(i))
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(m)
			e2:SetLabel(ct)
			e2:SetLabelObject(e1)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
end
function cm.spellcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function cm.spelltg(i,ct)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local t={c:GetActivateEffect()}
		local ae=t[i]
		local ftg=ae:GetTarget()
		if chk==0 then
			e:SetCostCheck(false)
			return not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk)
		end
		if ae:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
			e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		else e:SetProperty(0) end
		if ftg then
			e:SetCostCheck(false)
			ftg(e,tp,eg,ep,ev,re,r,rp,chk)
		end
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		local le={c:IsHasEffect(m)}
		for _,v in pairs(le) do if ct==v:GetLabel() and v:GetLabelObject()~=e then v:GetLabelObject():UseCountLimit(tp) end end
	end
end
function cm.spellop(i)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		local t={e:GetHandler():GetActivateEffect()}
		local ae=t[i]
		local fop=ae:GetOperation()
		fop(e,tp,eg,ep,ev,re,r,rp)
	end
end
