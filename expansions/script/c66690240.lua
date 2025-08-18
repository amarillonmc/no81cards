--蒸汽朋克·时空征服者
local s,id,o=GetID()
function s.initial_effect(c)

	-- 调整1只以上＋调整以外的怪兽1只以上
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),aux.NonTuner(nil),nil,s.mfilter,0,99)
	
	-- 这张卡的攻击力上升双方基本分差的数值
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	
	-- 自己·对方的主要阶段，从卡组把1张「蒸汽朋克」魔法·陷阱卡送去墓地才能发动，这个效果变成和那张魔法·陷阱卡发动时的效果相同
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,id)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.cpcon)
	e2:SetCost(s.cpcost)
	e2:SetTarget(s.cptg)
	e2:SetOperation(s.cpop)
	c:RegisterEffect(e2)
	
	-- 对方把手卡的怪兽的效果发动时，把1张手卡除外才能发动，那个效果无效并除外
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.negcon)
	e3:SetCost(s.negcost)
	e3:SetTarget(s.negtg)
	e3:SetOperation(s.negop)
	c:RegisterEffect(e3)
end

-- 调整1只以上＋调整以外的怪兽1只以上
function s.mfilter(c,syncard)
	return c:IsTuner(syncard) or c:IsNotTuner(syncard)
end

-- 这张卡的攻击力上升双方基本分差的数值
function s.atkval(e,c)
	return math.abs(Duel.GetLP(0)-Duel.GetLP(1))
end

-- 自己·对方的主要阶段，从卡组把1张「蒸汽朋克」魔法·陷阱卡送去墓地才能发动，这个效果变成和那张魔法·陷阱卡发动时的效果相同
function s.cpcon(e,tp)
	return Duel.IsMainPhase() and Duel.GetTurnCount()~=e:GetHandler():GetFlagEffectLabel(id)
end

function s.cpfilter(c)
    if not (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x666b) and c:IsAbleToGraveAsCost()) then
        return false
    end
    local te = c:CheckActivateEffect(false,true,false)
    return te and te:GetOperation() ~= nil
end

function s.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end

function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.cpfilter,tp,LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.SelectMatchingCard(tp,s.cpfilter,tp,LOCATION_DECK,0,1,1,nil)
	local te=g:GetFirst():CheckActivateEffect(false,true,false)
	e:SetLabelObject(te)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	Duel.ClearOperationInfo(0)
end

function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end

-- 对方把手卡的怪兽的效果发动时，把1张手卡除外才能发动，那个效果无效并除外
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep==1-tp and loc==LOCATION_HAND and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end

function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil)
		or Duel.IsPlayerAffectedByEffect(tp,66690330) end
	if Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil)
		and (not Duel.IsPlayerAffectedByEffect(tp,66690330) or not Duel.SelectYesNo(tp,aux.Stringid(66690330,0))) then
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	    Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end

function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
