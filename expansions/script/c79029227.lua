--乌萨斯·狙击干员-早露
function c79029227.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),2)
	c:EnableReviveLimit()
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCondition(c79029227.tgcon)
	e1:SetTarget(c79029227.tgtg)
	e1:SetOperation(c79029227.tgop)
	c:RegisterEffect(e1)
	--seq
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(79029227,10)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetTarget(c79029227.mvtg)
	e2:SetOperation(c79029227.mvop)
	c:RegisterEffect(e2)
end
function c79029227.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()>=5 and Duel.GetAttackTarget()~=nil
end
function c79029227.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()~=0 then
			return end
	end
	local b1=Duel.IsExistingMatchingCard(aux.TRUE,1-tp,LOCATION_HAND,0,2,nil)
	local b2=Duel.IsExistingTarget(aux.TRUE,1-tp,LOCATION_SZONE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(79029227,0),aux.Stringid(79029227,1))
		elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(79029227,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(79029227,1))+1
	end
	e:SetLabel(op)
	if op~=0 then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	else
		e:SetProperty(0)
	end
end
function c79029227.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
	local op=e:GetLabel()
	if op~=1 then
		local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
		if g:GetCount()==0 then return end
		local sg=g:RandomSelect(1-tp,2)
		Debug.Message("咦，难道出故障了？呀啊！")
		Duel.Hint(HINT_SOUND,0,aux.Stringid(79029227,6))
		Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
		end
	if op~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,1-tp,LOCATION_SZONE,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_RULE+REASON_EFFECT)
		Debug.Message("瞄准，发射！")
		Duel.Hint(HINT_SOUND,0,aux.Stringid(79029227,7))
	end
end
function c79029227.mvfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xa900)
end
function c79029227.bfil1(c)
	return c:GetSequence()==5
end
function c79029227.bfil2(c)
	return c:GetSequence()==6
end
function c79029227.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local x1=not Duel.IsExistingMatchingCard(c79029227.bfil1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local x2=not Duel.IsExistingMatchingCard(c79029227.bfil2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local x3=x1 or x2
	local b1=Duel.IsExistingMatchingCard(c79029227.mvfilter1,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0
	if chk==0 then return b1 or x3 end
	local op=0
	if b1 and x3 then op=Duel.SelectOption(tp,aux.Stringid(79029227,2),aux.Stringid(79029227,3))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(79029227,2))
	else op=Duel.SelectOption(tp,aux.Stringid(79029227,3))+1 end
	e:SetLabel(op)
end
function c79029227.mvop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(25163979,3))
		local g=Duel.SelectMatchingCard(tp,c79029227.mvfilter1,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
		if g:GetCount()>0 then
		Duel.SwapSequence(e:GetHandler(),g:GetFirst())
		Debug.Message("各位，按照计划行动吧。")
		Duel.Hint(HINT_SOUND,0,aux.Stringid(79029227,8))
		end
	else
	local x1=not Duel.IsExistingMatchingCard(c79029227.bfil1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local x2=not Duel.IsExistingMatchingCard(c79029227.bfil2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	if x1 and x2 then
	op=Duel.SelectOption(tp,aux.Stringid(79029227,4),aux.Stringid(79029227,5))
	elseif x1 then
		op=Duel.SelectOption(tp,aux.Stringid(79029227,4))
	elseif x2 then
		op=Duel.SelectOption(tp,aux.Stringid(79029227,5))+1
	else
	return false
	end
	if op==0 then
	Duel.MoveSequence(e:GetHandler(),5)
	else
	Duel.MoveSequence(e:GetHandler(),6) 
	end
		Debug.Message("早露，相信自己，你可以的。")
		Duel.Hint(HINT_SOUND,0,aux.Stringid(79029227,9))
end
end
