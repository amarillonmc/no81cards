--空想世界的连理樱
--21.06.23
local m=11451582
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(cm.reptg)
	e3:SetValue(cm.repval)
	e3:SetOperation(cm.repop)
	c:RegisterEffect(e3)
end
function cm.filter(c,tp)
	return c:IsSummonPlayer(1-tp)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,tp)
end
function cm.lvplus(c)
	if c:GetLevel()>=1 then return c:GetLevel() elseif c:GetRank()>=1 then return c:GetRank() elseif c:GetLink()>=1 then return c:GetLink() else return 0 end
end
function cm.spfilter(c,e,tp,g)
	return c:IsSetCard(0x97f) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and g:GetSum(cm.lvplus)>=c:GetRank()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,eg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,eg)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		eg:ForEach(Card.RegisterFlagEffect,m,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetCondition(cm.con)
		e1:SetValue(cm.efilter)
		e1:SetOwnerPlayer(tp)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
	end
end
function cm.cfilter(c)
	return c:IsFaceup() and c:GetFlagEffect(m)~=0
end
function cm.con(e)
	return Duel.IsExistingMatchingCard(cm.cfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function cm.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x9f38) and c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanOverlay() and eg:IsExists(cm.repfilter,1,nil,tp) and #eg==1 end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.SetTargetCard(eg)
		return true
	else return false end
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.Overlay(g:GetFirst(),e:GetHandler())
end