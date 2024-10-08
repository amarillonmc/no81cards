--魔合成-悲叹与绝望以及拒绝
local m=40009677
local cm=_G["c"..m]
cm.named_with_MagicCombineMagic=1
function cm.Spiritualist(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Spiritualist
end
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
function cm.cfilter1(c)
	return c:GetType()==TYPE_SPELL and c:IsAbleToRemoveAsCost() and c:CheckActivateEffect(true,true,false)~=nil  
end
function cm.cfilter2(c)
	return (c:GetType()==TYPE_SPELL or c:IsType(TYPE_QUICKPLAY))
	and c:IsAbleToRemoveAsCost() and c:CheckActivateEffect(true,true,false)~=nil  
end
function cm.cfilterz(c)
	return c:IsFaceup() and cm.Spiritualist(c)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if not Duel.IsExistingMatchingCard(cm.cfilterz,tp,4,0,1,nil) then return end
	cm_copy = false
	local g = {}
	if Duel.IsPlayerAffectedByEffect(tp,40011471) then
		g=Duel.GetMatchingGroup(cm.cfilter2,tp,LOCATION_GRAVE,0,nil)
	else
		g=Duel.GetMatchingGroup(cm.cfilter1,tp,LOCATION_GRAVE,0,nil)
	end
	if #g<=0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then 
		Duel.Hint(3,tp,HINTMSG_REMOVE)	
		local sg=g:Select(tp,1,1,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_COST)
		cm_copy = true
		local te,ceg,cep,cev,cre,cr,crp=sg:GetFirst():CheckActivateEffect(true,true,true)
		e:SetProperty(te:GetProperty())  
		local tg=te:GetTarget()  
		if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end  
		te:SetLabelObject(e:GetLabelObject())  
		e:SetLabelObject(te)  
		Duel.ClearOperationInfo(0)  
	end
end
function cm.filter(c)
	return c:IsFaceup() and c:GetOriginalRace()&RACE_ZOMBIE~=0
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
		e3:SetValue(0)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
		Duel.BreakEffect()
		if cm_copy then
		cm_copy = false
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