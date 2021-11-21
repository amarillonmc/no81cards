--天命教骑 月光
if not pcall(function() require("expansions/script/c16104200") end) then require("script/c16104200") end
local m,cm=rscf.DefineCard(16104228,"CHURCH_KNIGHT")
function cm.initial_effect(c)
	local e0,e0_1=rkch.PenTri(c,m)
	e0:SetCondition(cm.con)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	local e1=rkch.PenSpLimit(c,true)
	--fenjiexian--
	local ea=Effect.CreateEffect(c)
	ea:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	ea:SetType(EFFECT_TYPE_FIELD)
	ea:SetRange(LOCATION_MZONE)
	ea:SetTargetRange(LOCATION_MZONE,0)
	ea:SetCondition(cm.thcon)
	ea:SetValue(1)
	c:RegisterEffect(ea)
	local eb=rkch.GainEffect(c,m)
	--control
	local ew=Effect.CreateEffect(c)
	ew:SetCategory(CATEGORY_CONTROL)
	ew:SetDescription(aux.Stringid(m,0))
	ew:SetType(EFFECT_TYPE_QUICK_O)
	ew:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ew:SetCode(EVENT_FREE_CHAIN)
	ew:SetRange(LOCATION_MZONE) 
	ew:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	ew:SetCountLimit(1)
	ew:SetCondition(rkch.gaincon(m))
	ew:SetTarget(cm.target)
	ew:SetOperation(cm.operation)
	c:RegisterEffect(ew)
	--add setcode
	local ed=Effect.CreateEffect(c)
	ed:SetType(EFFECT_TYPE_FIELD)
	ed:SetRange(LOCATION_MZONE)
	ed:SetTargetRange(LOCATION_MZONE,0)
	ed:SetTarget(cm.lvtg)
	ed:SetCode(EFFECT_ADD_SETCODE)
	ed:SetCondition(rkch.gaincon(m))
	ed:SetValue(0x3ccd)
	c:RegisterEffect(ed)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetRange(LOCATION_MZONE)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	local ef=rkch.MonzToPen(c,m,EVENT_RELEASE,true)
end
cm.dff=true
function cm.lvtg(e,c)
	return not c:IsOriginalSetCard(0x3ccd) and c:GetOwner()~=e:GetHandlerPlayer()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentChain()==0
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
   return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.filter(c)
	return c:IsControlerCanBeChanged()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.filter(chkc) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,1-tp,LOCATION_REASON_CONTROL)
	if chk==0 then return ft>0 and Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_MZONE,1,nil) end
	local ct=math.min(ft,2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_MZONE,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,#g,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.GetControl(tg,tp)
end
function cm.eftg(e,c)
	return not c:IsOriginalSetCard(0x3ccd) and c:GetOwner()~=e:GetHandlerPlayer()
end