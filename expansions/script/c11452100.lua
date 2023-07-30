--限界掌匙人『21』
--23.07.30
local cm,m=GetID()
function cm.initial_effect(c)
	--s summon
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(aux.chainreg)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.reccon)
	e3:SetOperation(cm.recop)
	c:RegisterEffect(e3)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.con)
	e2:SetCost(cm.spcost)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.reccon(e,tp,eg,ep,ev,re,r,rp)
	return re and e:GetHandler():GetFlagEffect(1)>0
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	local chk=0
	local hg=Duel.GetFieldGroup(1-rp,LOCATION_HAND,0)
	local mg=hg:Filter(Card.IsType,nil,TYPE_MONSTER)
	local ct=mg:GetSum(Card.GetLevel)+#hg-#mg
	if ct>=10 and ct<=16 then chk=1 end
	if ct>=17 and ct<=20 then chk=2 end
	if ct>=21 then chk=3 end
	if Duel.IsPlayerCanDraw(1-rp,1) and Duel.SelectYesNo(1-rp,aux.Stringid(m,chk)) and Duel.Draw(1-rp,1,REASON_EFFECT)>0 then
		local hg=Duel.GetFieldGroup(1-rp,LOCATION_HAND,0)
		local mg=hg:Filter(Card.IsType,nil,TYPE_MONSTER)
		local ct=mg:GetSum(Card.GetLevel)+#hg-#mg
		Duel.ConfirmCards(rp,hg)
		if ct>21 then Duel.SendtoDeck(hg,nil,2,REASON_EFFECT) else Duel.ShuffleHand(1-rp) end
	end 
end
function cm.cfilter1(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_HAND)
end
function cm.cfilter2(c,tp,ec)
	if not c:IsControler(tp) or c:IsPublic() or not c:IsLocation(LOCATION_HAND) then return end
	local eset={ec:IsHasEffect(0x10000000+m)}
	for _,te in pairs(eset) do
		if te:GetLabel()&c:GetType()>0 then return false end
	end
	return true
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter1,1,nil,tp)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.cfilter2,1,nil,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tg=eg:FilterSelect(tp,cm.cfilter2,1,1,nil,tp,c)
	Duel.ConfirmCards(1-tp,tg)
	e:SetLabel(tg:GetFirst():GetType()&0x7)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1050)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetLabel(e:GetLabel())
	e3:SetCondition(cm.econ)
	e3:SetValue(cm.eval)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetLabel(e:GetLabel())
	e2:SetLabelObject(e3)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(0x10000000+m)
	e2:SetCondition(function(e) return e:GetLabelObject():GetLabel()<100 end)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
end
function cm.econ(e)
	return e:GetLabel()<100
end
function cm.eval(e,te)
	local c=e:GetHandler()
	local res=te:IsActivated() and e:GetOwnerPlayer()~=te:GetOwnerPlayer() and e:GetLabel()&te:GetActiveType()>0
	if res then
		e:SetLabel(100)
	end
	return res
end