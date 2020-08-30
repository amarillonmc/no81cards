--罗德岛·狙击干员-安德切尔
function c79029163.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c79029163.dstg)
	e1:SetOperation(c79029163.dsop)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c79029163.disop)
	e5:SetLabel(c:GetSequence())
	c:RegisterEffect(e5)
end
function c79029163.disop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetColumnGroup():IsContains(re:GetHandler()) and re:GetHandler():IsControler(1-tp) then
	Duel.Hint(HINT_CARD,0,79029163)
	Duel.NegateEffect(ev)
end 
end
function c79029163.filter(c)
	return c:IsFaceup() and (c:IsCanBeSynchroMaterial() or c:IsCanBeXyzMaterial(nil))
end
function c79029163.dstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c79029163.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029163.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c79029163.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c79029163.dsop(e,c,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=Duel.GetFirstTarget()
	Debug.Message("各位，开始狩猎吧。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029163,0))
	if tc and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_XYZ_MATERIAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c79029163.synlimit)
	tc:RegisterEffect(e2)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c79029163.synlimit)
	tc:RegisterEffect(e2)   
end
end
function c79029163.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0xa900)
end
