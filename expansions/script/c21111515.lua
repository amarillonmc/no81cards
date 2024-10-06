--捕食植物 灰染毒播疫龙
function c21111515.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x10f3),3,true)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_MATERIAL_LIMIT)
	e0:SetValue(c21111515.matlimit)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2,21111515)
	e2:SetCondition(c21111515.con2)
	e2:SetOperation(c21111515.op2)
	c:RegisterEffect(e2)
end
function c21111515.matlimit(e,c,fc,st)
	if st~=SUMMON_TYPE_FUSION then return true end
	return c:IsControler(fc:GetControler()) and c:IsLocation(LOCATION_ONFIELD+LOCATION_HAND)
end
function c21111515.q(c,e)
	return c:IsSummonLocation(LOCATION_EXTRA) and not c:IsImmuneToEffect(e) and c:IsFaceup()
end
function c21111515.con2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-e:GetHandlerPlayer() and eg:Filter(c21111515.q,nil,e)
end
function c21111515.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c21111515.q,nil,e)
	if #g>0 then
		for tc in aux.Next(g) do
		tc:AddCounter(0x1041,1)
			if tc:GetLevel()>1 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetCondition(c21111515.lvcon)
			e1:SetValue(1)
			tc:RegisterEffect(e1)
			end
		end
	end	
end
function c21111515.lvcon(e)
	return e:GetHandler():GetCounter(0x1041)>0
end