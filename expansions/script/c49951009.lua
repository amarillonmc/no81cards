--混沌病毒-莱斯特
function c49951009.initial_effect(c)
   --xyz summon
	aux.AddXyzProcedure(c,nil,1,3,c49951009.ovfilter,aux.Stringid(49951009,0),99,c49951009.xyzop)
	c:EnableReviveLimit() 
	 --atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49951009,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c49951009.spcon1)
	e2:SetOperation(c49951009.atkop)
	c:RegisterEffect(e2)
	 --Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(49951009,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,49951009)
	e3:SetCost(c49951009.cost)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c49951009.destg)
	e3:SetOperation(c49951009.desop)
	c:RegisterEffect(e3)
	--get effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(49951009,2))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLED)
	e4:SetCondition(c49951009.rmcon)
	e4:SetTarget(c49951009.rmtg)
	e4:SetOperation(c49951009.rmop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(49951009,3))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1,49951002)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCost(aux.exccon)
	e5:SetTarget(c49951009.sptg)
	e5:SetOperation(c49951009.spop)
	c:RegisterEffect(e5)
end
function c49951009.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x823) and c:IsLevel(1) and not c:IsCode(49951009)
end
function c49951009.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,49951009)==0 end
	Duel.RegisterFlagEffect(tp,49951009,RESET_PHASE+PHASE_END,0,1)
end
function c49951009.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c49951009.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(math.ceil(Duel.GetLP(1-tp)/2))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c49951009.desfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk) and not c:IsCode(49951009)
end
function c49951009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c49951009.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c49951009.desfilter(chkc,c:GetAttack()) end
	if chk==0 then return Duel.IsExistingTarget(c49951009.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetAttack()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c49951009.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c49951009.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
		Duel.Destroy(tc,REASON_EFFECT)
		end
function c49951009.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	e:SetLabelObject(bc)
	return  bc and bc:IsStatus(STATUS_OPPO_BATTLE) and bc:IsRelateToBattle()
end
function c49951009.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabelObject():IsAbleToRemove() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetLabelObject(),1,0,0)
end
function c49951009.rmop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() and bc:IsControler(1-tp) then
		Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
	end
end
function c49951009.sfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x823)
end
function c49951009.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c49951009.sfilter(chkc,ft) end
	if chk==0 then return ft>-1 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c49951009.sfilter,tp,LOCATION_MZONE,0,1,nil,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c49951009.sfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c49951009.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
