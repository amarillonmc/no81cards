--【日】月下的雏菊之丘
local m=33711120
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x246)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.splimit)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(cm.condition)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	--ct
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(function (e,tp) return Duel.GetTurnPlayer() == tp end)
	e4:SetTarget(cm.chtg2)
	e4:SetOperation(cm.chop2)
	c:RegisterEffect(e4)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return se:GetHandler()~=e:GetHandler()
end
function cm.check(c)
	return c:IsFaceup() and c:IsSetCard(0x440)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(cm.check,tp,LOCATION_MZONE,0,nil)==0
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0x440) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		if Duel.Damage(tp,atk+def,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
function cm.chtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.chop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=c:GetCounter(0x246)
	if Duel.GetMatchingGroupCount(cm.check,tp,LOCATION_MZONE,0,nil)==0 then
		c:RemoveCounter(tp,0x246,num,REASON_EFFECT)
	else
		c:AddCounter(0x246,1)
		if c:GetCounter(0x246)==3 then
			c:SetEntityCode(33711123,true)
			c:ReplaceEffect(33711123,0,0)
			Duel.Hint(HINT_CARD,1,33711123)
		end
	end
end
