local m=15000186
local cm=_G["c"..m]
cm.name="观鸟者"
function cm.initial_effect(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
	--attack limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--The Bird Watcher
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(cm.mttg)
	e4:SetOperation(cm.mtop)
	c:RegisterEffect(e4)
end
function cm.filter(c,e,tp,id)
	return c:GetTurnID()==id and not c:IsReason(REASON_RETURN) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function cm.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE)
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	Duel.Hint(HINT_SELECTMSG,1-p,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(1-p,cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,1-p,Duel.GetTurnCount())
	if g:GetCount()~=0 then
		Duel.SpecialSummon(g,0,1-p,1-p,false,false,POS_FACEUP)
	end
end