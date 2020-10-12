--新宇宙勇机 雄伟疾驰
function c40009241.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009241,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,40009241)
	e1:SetTarget(c40009241.target)
	e1:SetOperation(c40009241.operation)
	c:RegisterEffect(e1)
	--xyzlv
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_XYZ_LEVEL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c40009241.xyzlv)
	e2:SetLabel(4)
	c:RegisterEffect(e2) 
	--get effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetCode(EFFECT_PIERCE)
	e3:SetCondition(c40009241.condition)
	c:RegisterEffect(e3) 
end
function c40009241.condition(e)
	return e:GetHandler():GetRace()==RACE_MACHINE 
end
function c40009241.xyzlv(e,c,rc)
	if rc:IsRace(RACE_MACHINE) then
		return c:GetLevel()+0x10000*e:GetLabel()
	else
		return c:GetLevel()
	end
end
function c40009241.filter(c)
	return c:IsFaceup() and c:GetCounter(0x1f1b)==0 and c:IsType(TYPE_XYZ) and c:IsSetCard(0x1f1b) and c:IsCanAddCounter(0x1f1b,1)
end
function c40009241.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c40009241.filter(chkc) and chkc:IsCanAddCounter(0x1f1b,1) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c40009241.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c40009241.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c40009241.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) or tc:GetCounter(0x1f1b)>0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			tc:AddCounter(0x1f1b,1)
		end
	end
end

