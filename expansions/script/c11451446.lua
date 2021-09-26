--反抗革命的卫兵
local m=11451446
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,99518961)
	c:EnableReviveLimit()
	--spsummon procedure
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,1)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop2)
	c:RegisterEffect(e2)
	--avoid damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(cm.val)
	c:RegisterEffect(e3)
	--control
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_CONTROL)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.ctcon)
	e4:SetTarget(cm.cttg)
	e4:SetOperation(cm.ctop)
	c:RegisterEffect(e4)
end
function cm.filter1(c,tp)
	return c:IsReleasable() and Duel.GetMZoneCount(1-tp,c,tp)>0
end
function cm.filter2(c)
	return aux.IsCodeListed(c,99518961) and c:IsType(TYPE_MONSTER)
end
function cm.filter3(c,e,tp)
	return c:IsLevelBelow(3) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.filter4(c)
	return (aux.IsCodeListed(c,99518961) and c:IsType(TYPE_MONSTER)) or c:IsType(TYPE_NORMAL)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.filter1,tp,0,LOCATION_MZONE,1,nil,tp) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_MZONE,0,1,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.filter1,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,0,1,1-tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter3),1-tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,1-tp)
	if g:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.SpecialSummon(sg,0,1-tp,1-tp,false,false,POS_FACEUP)
	end
end
function cm.val(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandlerPlayer()
	return tp~=p and Duel.IsExistingMatchingCard(cm.filter4,p,0,LOCATION_MZONE,4,nil)
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.GetControl(c,tp)
	end
end