--冰汽时代 祷告牧师
local m=33502212
local cm=_G["c"..m]
Duel.LoadScript("c33502200.lua")
function cm.initial_effect(c)
	local e1=syu.turnup(c,m,nil,nil,cm.turnupop,CATEGORY_CONTROL)
	local e2=syu.tograve(c,m,nil,nil,cm.gop,nil)
end
function cm.turnupop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,1-tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		if not Duel.IsPlayerAffectedByEffect(tp,33502206) then Duel.SetLP(tp,Duel.GetLP(tp)-1000) end
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.GetControl(sg,tp)
	end
end
function cm.gop(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetTargetRange(1,0)
	e2:SetValue(cm.efilter)
	e2:SetTarget(cm.tg)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and e:GetOwnerPlayer()~=te:GetOwnerPlayer()
end
function cm.tg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x1a81) and c:IsType(TYPE_MONSTER)
end