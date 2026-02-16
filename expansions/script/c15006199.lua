local m=15006199
local cm=_G["c"..m]
cm.name="巡星兽 终北极光"
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x9f44),2,true)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9f44))
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.atkcon)
	e3:SetTarget(cm.atktg)
	e3:SetOperation(cm.atkop)
	c:RegisterEffect(e3)
	--sp
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,m)
	e4:SetCondition(cm.spcon)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
end
function cm.atkfilter(c,eg,e)
	return c:IsFaceupEx() and eg:IsExists(cm.atk2filter,1,nil,c:GetCode()) and #eg==1 and c:IsCanBeEffectTarget(e)
end
function cm.atk2filter(c,code)
	return c:IsFaceup() and c:IsCode(code) and c:IsSetCard(0x9f44)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 and eg:GetFirst():IsSetCard(0x9f44) and not eg:IsContains(e:GetHandler())
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ec=eg:GetFirst()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and cm.atkfilter(chkc,eg,e) end
	if chk==0 then return true end
	ec:CreateEffectRelation(e)
	local ag=Duel.GetMatchingGroup(cm.atkfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,eg,e)
	local sg=Group.CreateGroup()
	if ag:GetCount()==1 then
		sg=ag:Clone()
		Duel.SetTargetCard(sg)
	else
		Duel.Hint(HINTMSG_DESTROY,tp,HINTMSG_TARGET)
		sg=Duel.SelectTarget(tp,aux.IsInGroup,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,ag)
	end
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
	if #eg==1 and eg:GetFirst():IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(tc:GetBaseAttack())
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		eg:GetFirst():RegisterEffect(e2)
	end
end
function cm.cfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousSetCard(0x9f44)
		and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end