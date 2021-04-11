--
function c33711404.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Destroy & Remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(c33711404.op1)
	c:RegisterEffect(e1)
	--Seqcheck
	if not c33711404.global_check then
		c33711404.global_check=true
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_LEAVE_FIELD_P)
		e3:SetOperation(c33711404.op3)
		Duel.RegisterEffect(e3,0)
	end
	--Movetofield
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetOperation(c33711404.op4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetOperation(c33711404.op5)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
end
--
function c33711404.op3(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:GetFlagEffect(33711404)>0 then
			tc:ResetFlagEffect(33711404)
		end
		if not tc:IsLocation(LOCATION_FZONE) then
			local col=aux.GetColumn(tc)
			if tc:GetDestination()==LOCATION_REMOVED then
				tc:RegisterFlagEffect(33711404,0,0,0,col)
			elseif tc:IsReason(REASON_DESTROY) then
				tc:RegisterFlagEffect(33711405,0,0,0,col)
			end
		end
	end
end
--
function c33711404.ofilter1(c,col)
	return col==aux.GetColumn(c) and c:IsAbleToRemove()
end
function c33711404.ofilter2(c,col)
	return col==aux.GetColumn(c)
end
function c33711404.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=0
	local dg1=Group.CreateGroup()
	local dg2=Group.CreateGroup()
	for tc in aux.Next(eg) do
		local col=tc:GetFlagEffectLabel(33711404)
		local col2=tc:GetFlagEffectLabel(33711405)
		if col then
			local sg=Duel.GetMatchingGroup(c33711404.ofilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,col)
			dg1:Merge(sg)
		end
		if col2 then
			local sg=Duel.GetMatchingGroup(c33711404.ofilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,col2)
			dg2:Merge(sg)
		end
	end
	if dg1:GetCount()>0 then
		Duel.Hint(HINT_CARD,1-tp,c:GetOriginalCode())
		Duel.Remove(dg1,POS_FACEUP,REASON_EFFECT)
	end
	if dg2:GetCount()>0 then
		Duel.Hint(HINT_CARD,1-tp,c:GetOriginalCode())
		Duel.Destroy(dg2,REASON_EFFECT)
	end
end
--
function c33711404.op4(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c33711404.op5(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetLabel()~=0 then return end
	Duel.Damage(tp,2000,REASON_RULE)
	local c=e:GetHandler()
	if c:IsForbidden() then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE,0)<1 then return end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
--
