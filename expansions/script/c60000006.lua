--AiNo.1 漫色幻花
function c60000006.initial_effect(c)
	--超量网络构筑
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,2,c60000006.ovfilter,aux.Stringid(60000006,0),99,c60000006.xyzop)
	c:EnableReviveLimit()
	--威风抗性
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
end
aux.xyz_number[60000006]=1
function c60000006.ovfilter(c)
	return c:IsFaceup()
	and c:IsType(TYPE_LINK) and c:GetLink()>=2
end
function c60000006.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,60000006)==0 end
	Duel.RegisterFlagEffect(tp,60000006,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end