--银流幻想者·嗥铃
local m=33701601
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(cm.spcon1)
	e0:SetCost(cm.cost)
	e0:SetTarget(cm.rtg)
	e0:SetOperation(cm.op)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(cm.spcon2)
	c:RegisterEffect(e1)
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,33701600)
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,33701600)
end
--
function funcoin(tp,count)
	local Coin_Tab={}
	for i=1,count do
		table.insert(Coin_Tab,Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))) 
	end
	return table.unpack(Coin_Tab)
end
function fundiss(tp,count1,count2)
	local Coin_Diss={}
	for i=1,count1 do
		table.insert(Coin_Diss,Duel.SelectOption(tp,aux.Stringid(m,4),aux.Stringid(m,5),aux.Stringid(m,6),aux.Stringid(m,7),aux.Stringid(m,8),aux.Stringid(m,9))+1) 
	end
	if count2 then
		for j=1,count2 do
			table.insert(Coin_Diss,Duel.SelectOption(tp,aux.Stringid(m,4),aux.Stringid(m,5),aux.Stringid(m,6),aux.Stringid(m,7),aux.Stringid(m,8),aux.Stringid(m,9))+1) 
		end
	end
	return table.unpack(Coin_Diss)
end
function cm.cpfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
		and c:CheckActivateEffect(true,true,false)~=nil and (c.toss_coin or c.toss_dice)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()==0 or e:GetLabel()==3 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cm.cpfilter,tp,LOCATION_GRAVE,0,1,nil) and e:GetHandler():IsAbleToRemoveAsCost()
	end
	e:SetLabel(0)
	if Duel.GetMatchingGroupCount(nil,tp,LOCATION_ONFIELD,0,e:GetHandler())==0 then
		e:SetLabel(3)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)
	end
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local ce=e:GetLabelObject()
	if not ce then return false end
	f_tmp1=funcoin
	f_tmp2=fundiss  
	if e:GetLabel()==3 then
		f_tmp1=Duel.TossCoin
		f_tmp2=Duel.TossDice
		Duel.TossCoin=funcoin
		Duel.TossDice=fundiss
	end
	e:SetLabelObject(ce:GetLabelObject())
	local fop=ce:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==3 then
		Duel.TossCoin=f_tmp1
		Duel.TossDice=f_tmp2
	end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end