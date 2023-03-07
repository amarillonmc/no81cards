--节点神经圆弧
local m=14000142
local cm=_G["c"..m]
cm.named_with_Circlia=1
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--avoid battle damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetCondition(cm.condition)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e4)
	local e_h=Effect.CreateEffect(c)
	e_h:SetType(EFFECT_TYPE_SINGLE)
	e_h:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e_h:SetCondition(cm.checkcon)
	c:RegisterEffect(e_h)
end
function cm.CIR(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Circlia
end
function cm.checkcon(e)
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_CHAINING,true)
	if res then
		return trp~=e:GetHandlerPlayer()
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp==tp then
		c:ResetEffect(EFFECT_TRAP_ACT_IN_HAND,RESET_CODE)
		return 
	end
	local e_h=Effect.CreateEffect(c)
	e_h:SetType(EFFECT_TYPE_SINGLE)
	e_h:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e_h:SetReset(RESET_CHAIN+RESET_EVENT+EVENT_CHAINING)
	c:RegisterEffect(e_h)
end
function cm.filter(c,tp)
	return c:GetSummonPlayer()==1-tp
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,tp)
end
function cm.spfilter(c,e,tp)
	return cm.CIR(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.indcon(c)
	return cm.CIR(c) and c:IsFaceup()
end
function cm.condition(e)
	return Duel.GetMatchingGroupCount(cm.indcon,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)>0
end