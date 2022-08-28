local m=90700074
local cm=_G["c"..m]
cm.name="煌牙之龙战士"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(cm.adv_su_proc_con)
	e2:SetOperation(cm.adv_su_proc_op)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetValue(SUMMON_TYPE_ADVANCE+SUMMON_VALUE_SELF)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_MOVE)
	e3:SetCondition(cm.recon)
	e3:SetTarget(cm.retg)
	e3:SetOperation(cm.reop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetOperation(cm.drop)
	c:RegisterEffect(e4)
end
function cm.advfilter(c)
	return not c:IsLocation(LOCATION_DECK+LOCATION_HAND) and c:IsReason(REASON_SUMMON) and c:IsReason(REASON_MATERIAL)
end
function cm.adv_su_proc_con(e,c,minc)
	if c==nil then return true end
	local num=Duel.GetMatchingGroupCount(cm.advfilter,tp,0x1ff,0x1ff,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and num>0
end
function cm.adv_su_proc_op(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.SendtoHand(Duel.GetMatchingGroup(cm.advfilter,tp,0x1ff,0x1ff,nil),nil,REASON_COST)
end
function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_SUMMON) and c:IsReason(REASON_MATERIAL) and not (c:IsPosition(POS_FACEDOWN) and c:IsLocation(LOCATION_REMOVED)) and not c:IsLocation(LOCATION_DECK)
end
function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.filter(c,e)
	return c:IsCode(m) and c:IsSummonable(true,e)
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil,e):GetFirst()
	if c and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Summon(tp,c,true,nil)
	end
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) then return end
	if eg:IsContains(e:GetHandler()) then return end
	local card=eg:GetFirst()
	local num=0
	while card do
		if card:IsSummonType(SUMMON_TYPE_ADVANCE) then
			num=num+card:GetMaterialCount()
		end
		card=eg:GetNext()
	end
	if num==0 then return end
	if Duel.IsPlayerCanDraw(e:GetHandler(),num) then
		Duel.Hint(HINT_CARD,tp,m)
		Duel.Draw(e:GetHandler(),num,REASON_EFFECT)
	end
end