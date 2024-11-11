local m=33590080
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),6,2,cm.ovfilter2,aux.Stringid(m,0))
	c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,m)
	e0:SetCondition(cm.spcon)
	e0:SetTarget(cm.sptg)
	e0:SetOperation(cm.spop)
	c:RegisterEffect(e0)
	--[[--up atk
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)]]
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetTarget(cm.reptg)
	e2:SetValue(cm.repval)
	c:RegisterEffect(e2)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e2:SetLabelObject(g)
	--[[--Position
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	--e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCategory(CATEGORY_POSITION+CATEGORY_ATKCHANGE)
	e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.poscon)
	e3:SetCost(cm.poscost)
	e3:SetTarget(cm.postg)
	e3:SetOperation(cm.posop)
	c:RegisterEffect(e3)]]
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	--e4:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetCountLimit(1,m+1)
	e4:SetCondition(cm.incon)
	e4:SetCost(cm.incost)
	e4:SetOperation(cm.inop)
	c:RegisterEffect(e4)
	--atk/def gain
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(cm.value)
	c:RegisterEffect(e5)
end
function StarFlow(x,y)
	local t=0
	if x==nil then x=0 end
	if y==nil then y=0 end
	if x>=y then
	    t=x
	else
	    t=y
	end
	if t==0 then return 0 end
	local sf=((x-y)/t)
    local formatted_num = string.format("%.2f",sf)
    local num = tonumber(formatted_num)*100
    return num
end
function cm.ovfilter2(c)
    local tp=c:GetControler()
	local x=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil):GetSum(Card.GetAttack)
	local y=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil):GetSum(Card.GetAttack)
    local sf=StarFlow(x,y)
	return c:IsFaceup() and c:GetAttack()>=(1800) and sf<=-25
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:GetAttack()>=(1800)  and c:IsCanBeXyzMaterial(c)
end
--[[function cm.atkval(e,c)
	return c:GetOverlayCount()*200
end]]
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    local c=e:GetHandler()
    local tp=c:GetControler()
	local x=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil):GetSum(Card.GetAttack)
	local y=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil):GetSum(Card.GetAttack)
    local sf=StarFlow(x,y)
    return Duel.GetTurnPlayer()~=tp and sf<=-25 and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and aux.dscon()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.ovfilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<0 or not Duel.IsExistingMatchingCard(cm.ovfilter,tp,LOCATION_MZONE,0,1,nil) then return end
	local g=Duel.SelectMatchingCard(tp,cm.ovfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(c,mg)
		end
		c:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(c,Group.FromCards(tc))
		Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		c:CompleteProcedure()
end
function cm.repfilter(c,tp)
    return c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_BATTLE)  and c:IsCanOverlay(tp) and c:GetDestination()==LOCATION_GRAVE
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE) and eg:IsExists(cm.repfilter,1,nil,tp) end
	local g=eg:Filter(cm.repfilter,nil,tp,tp)
	local tc=g:GetFirst()
	local container=e:GetLabelObject()
	container:Clear()
	local og=tc:GetOverlayGroup()
	if og:GetCount()>0 then
		Duel.SendtoGrave(og,REASON_RULE)
	end
	Duel.Overlay(c,Group.FromCards(tc))
	container:AddCard(tc)
	return true
end
function cm.repval(e,c)
	return e:GetLabelObject():IsContains(c)
end
--[[function cm.poscon(e,tp,eg,ep,ev,re,r,rp)
	local x=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil):GetSum(Card.GetAttack)
	local y=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil):GetSum(Card.GetAttack)
    local sf=StarFlow(x,y)
	return sf<=25
end
function cm.sefilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function cm.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanTurnSet() end
	if chk==0 then return Duel.IsExistingTarget(cm.sefilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.sefilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE) then
	    Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
    end
end]]
function cm.incost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local ct=Duel.GetOperatedGroup():GetFirst()
	e:SetLabelObject(ct)
end
function cm.incon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local x=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil):GetSum(Card.GetAttack)
	local y=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil):GetSum(Card.GetAttack)
    local sf=StarFlow(x,y)
	return bc and bc:IsControler(1-tp) and sf<=25
end
function cm.inop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=c:GetBattleTarget()
	local ct=e:GetLabelObject()
	--if not dc:IsRelateToEffect(e) then return end
	if ct:IsType(TYPE_MONSTER) then
	    local atk=ct:GetBaseAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		dc:RegisterEffect(e1)
	else
	    local atk=dc:GetBaseAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		dc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		dc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetValue(atk/2)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		dc:RegisterEffect(e3)
	end
end
function cm.value(e,c)
    local sc=e:GetHandler()
    local tp=sc:GetControler()
    local x=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil):GetSum(Card.GetAttack)
	local y=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil):GetSum(Card.GetAttack)
    local sf=StarFlow(x,y)
	return sf*10
end