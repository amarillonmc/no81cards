--邪心英雄 裂眦嚼魔
function c77000425.initial_effect(c) 
	aux.AddCodeList(c,94820406)
	c:EnableReviveLimit()
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND) 
	e1:SetCondition(c77000425.hspcon)
	e1:SetOperation(c77000425.hspop)
	c:RegisterEffect(e1)  
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c77000425.reptg)
	e2:SetValue(c77000425.repval)
	c:RegisterEffect(e2)  
	--copy 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,77000425) 
	e3:SetCondition(c77000425.cpcon) 
	e3:SetTarget(c77000425.cptg)
	e3:SetOperation(c77000425.cpop)
	c:RegisterEffect(e3)
end
function c77000425.spfilter(c,ft)
	return c:IsFaceup() and c:IsSetCard(0x6008) and c:IsReleasable()
		and (ft>0 or c:GetSequence()<5)
end
function c77000425.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c77000425.spfilter,tp,LOCATION_MZONE,0,1,nil,ft)
end
function c77000425.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c77000425.spfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.Release(g,REASON_COST)
end
function c77000425.cpcon(e,tp,eg,ep,ev,re,r,rp) 
	return rp==1-tp   
end 
function c77000425.filter(c)
	return (aux.IsCodeListed(c,94820406) or c:IsCode(94820406)) and c:IsType(TYPE_SPELL) and c:CheckActivateEffect(true,true,false)~=nil
end
function c77000425.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(c77000425.filter,tp,LOCATION_GRAVE,0,1,nil) end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e:SetCategory(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c77000425.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	local te=g:GetFirst():CheckActivateEffect(true,true,false)
	Duel.ClearTargetCard()
	e:SetProperty(te:GetProperty())
	e:SetLabel(te:GetLabel())
	e:SetLabelObject(te:GetLabelObject())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	te:SetLabel(e:GetLabel())
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c77000425.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local te=e:GetLabelObject()
	if te:GetHandler():IsRelateToEffect(e) then
		e:SetLabel(te:GetLabel())
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		te:SetLabel(e:GetLabel())
		te:SetLabelObject(e:GetLabelObject())  
		if tc:IsRelateToEffect(e) then 
			Duel.BreakEffect() 
		end  
	end
end
function c77000425.repfilter(c,tp)
	return c:GetOwner()==1-tp and c:IsReason(REASON_DESTROY) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and c:GetDestination()==LOCATION_GRAVE and c:IsAbleToRemove(POS_FACEDOWN) 
end
function c77000425.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c77000425.repfilter,1,nil,tp) end 
	local g=eg:Filter(c77000425.repfilter,nil,tp)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT+REASON_REDIRECT)
	return true 
end
function c77000425.repval(e,c)
	return false
end



