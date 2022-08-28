local m=53734013
local cm=_G["c"..m]
cm.name="游离的青缀"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(cm.con)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)==0 then return end
	local zone=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0xe000e0)
	Duel.Hint(HINT_ZONE,tp,zone)
	local flag=zone
	if tp==1 then zone=((zone&0xffff)<<16)|((zone>>16)&0xffff) end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetValue(zone)
	e1:SetReset(RESET_PHASE+Duel.GetCurrentPhase())
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetLabel(flag)
	e2:SetOperation(cm.spop)
	Duel.RegisterEffect(e2,tp)
end
function cm.spfilter(c,e,tp,dis)
	return (c:IsSetCard(0x3536) or c:IsCode(53734009)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,dis) and not Duel.IsExistingMatchingCard(function(c,tc)return tc:IsCode(c:GetCode()) and c:IsFaceup()end,tp,LOCATION_ONFIELD,0,1,nil,c)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local dis=e:GetLabel()
	if not Duel.CheckLocation(tp,LOCATION_MZONE,math.log(dis,2)) then return end
	e:Reset()
	if not Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,dis) then return end
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,dis)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,dis)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_REMOVE)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_MZONE,0,nil)
	if not c:IsAbleToRemove() or #g==0 or not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(g)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
