--嗔怨之耆婆耆婆迦
local m=64800201
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,cm.matfilter1,cm.matfilter2,true)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EVENT_CHAINING)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.negcon)
	e1:SetTarget(aux.nbtg)
	e1:SetOperation(cm.negop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.con1)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetCondition(cm.con2)
	e3:SetTarget(cm.atktg)
	e3:SetOperation(cm.atkop)
	c:RegisterEffect(e3)
end

cm.material_type=TYPE_FUSION
function cm.matfilter1(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsType(TYPE_FUSION)
end
function cm.matfilter2(c)
	return c:IsRace(RACE_WINDBEAST+RACE_BEAST+RACE_BEASTWARRIOR)
end

--e1
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) 
		and e:GetHandler():GetFlagEffect(m)==0
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local c=e:GetHandler()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.repop)
	if c:IsRelateToEffect(e) then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
	end
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		if e:GetHandler():IsOnField() then e:GetHandler():CancelToGrave() end
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	end
end

--e2
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT) and not re:GetHandler():IsLocation(LOCATION_DECK)  and c:IsPreviousPosition(POS_FACEUP)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,nil)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not tc:IsLocation(LOCATION_DECK) then
		Duel.SendtoDeck(tc,nil,2,REASON_RULE)
	end
end

function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_BATTLE)
		and e:GetHandler():GetReasonCard():IsRelateToBattle()
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local rc=e:GetHandler():GetReasonCard()
	rc:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,rc,1,0,0)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	if rc:IsRelateToEffect(e) and not rc:IsLocation(LOCATION_DECK) then
		Duel.SendtoDeck(rc,nil,2,REASON_RULE)
	end
end