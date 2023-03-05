--魔合成-悲叹与绝望以及拒绝
local m=40009677
local cm=_G["c"..m]
cm.named_with_MagicCombineMagic=1
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)		
end
function cm.MagicCombineDemon(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_MagicCombineDemon
end
function cm.cfilter(c)
	return c:GetType()==TYPE_SPELL and c:IsAbleToRemoveAsCost() and c:CheckActivateEffect(false,true,false)~=nil  
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) and Duel.IsPlayerAffectedByEffect(tp,40010330) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil):GetFirst() 
		Duel.Remove(sg,POS_FACEUP,REASON_COST)
		local te,ceg,cep,cev,cre,cr,crp=sg:CheckActivateEffect(false,true,true)
		e:SetProperty(te:GetProperty())  
		local tg=te:GetTarget()  
		if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end  
		te:SetLabelObject(e:GetLabelObject())  
		e:SetLabelObject(te)  
		Duel.ClearOperationInfo(0)  
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function cm.filter(c)
	return c:IsFaceup() and cm.MagicCombineDemon(c)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(tc:GetAttack()*2)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetValue(cm.tgoval)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetOwnerPlayer(tp)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CHANGE_DAMAGE)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(0,1)
		e3:SetValue(cm.damval)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
		Duel.BreakEffect()
		if e:GetLabel()==1 then
			local te=e:GetLabelObject()  
			if te then  
				e:SetLabelObject(te:GetLabelObject())  
				local op=te:GetOperation()  
				if op then op(e,tp,eg,ep,ev,re,r,rp) end  
			end
		end  
	end
end
function cm.tgoval(e,re,rp)
	return rp==1-e:GetOwnerPlayer()
end
function cm.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end