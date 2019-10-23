--超刻兽·时刻利爪·叛逆
function c40008547.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,c40008547.ffilter,3,63,false)
	--atk,def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(c40008547.value)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)	
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40008547,0))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c40008547.con)
	e3:SetTarget(c40008547.target)
	e3:SetOperation(c40008547.operation)
	c:RegisterEffect(e3)
	--atk/def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c40008547.valcheck)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c40008547.con)
	e5:SetOperation(c40008547.atkop)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(40008547,1))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c40008547.spcon1)
	e6:SetTarget(c40008547.destg)
	e6:SetOperation(c40008547.desop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetHintTiming(0,TIMING_END_PHASE)
	e7:SetCondition(c40008547.spcon2)
	c:RegisterEffect(e7)
end
function c40008547.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0xf17) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function c40008547.valcheck(e,c)
	local lv=c:GetMaterial():GetSum(Card.GetLevel)
	e:SetLabel(lv)
end
function c40008547.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local val=e:GetLabelObject():GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
end
function c40008547.value(e,c)
	return c:GetLevel()*200
end
function c40008547.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c40008547.filter1(c)
	return c:IsSetCard(0xf17) and c:IsType(TYPE_MONSTER) 
end
function c40008547.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c40008547.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40008547.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c40008547.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetLevel()*300)
end
function c40008547.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	  Duel.Recover(tp,tc:GetLevel()*400,REASON_EFFECT)
	end
end
function c40008547.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and not Duel.IsPlayerAffectedByEffect(tp,40008545)
end
function c40008547.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and Duel.IsPlayerAffectedByEffect(tp,40008545)
end
function c40008547.desfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c40008547.tdfilter(c)
	return c:IsSetCard(0xf17) and c:IsAbleToGrave()
end
function c40008547.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c40008547.desfilter,tp,0,LOCATION_MZONE,1,nil,c:GetAttack()) end
	local g=Duel.GetMatchingGroup(c40008547.desfilter,tp,0,LOCATION_MZONE,nil,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c40008547.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c40008547.desfilter,tp,0,LOCATION_MZONE,nil,c:GetAttack())
	if Duel.Destroy(g,REASON_EFFECT)==0 then return end 
	local dg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c40008547.tdfilter),tp,LOCATION_ONFIELD,0,nil)
	if dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(40008547,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=dg:Select(tp,1,1,nil)
		Duel.HintSelection(tg)
		Duel.SendtoGrave(tg,nil,0,REASON_EFFECT)
	end
end