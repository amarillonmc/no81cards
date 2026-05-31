--狂野伯吉斯异兽·寒武耙虾
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2,2)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	--发动陷阱
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(s.descost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetTarget(s.desreptg)
	e3:SetValue(s.desrepval)
	e3:SetOperation(s.desrepop)
	c:RegisterEffect(e3)
end
function s.efilter(e,re)
	return re:IsActiveType(TYPE_MONSTER) and re:GetOwner()~=e:GetOwner()
end

function s.cfilter(c)
	return c:IsAbleToGraveAsCost()
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

function s.filter1(c,e,tp,eg,ep,ev,re,r,rp)
	-- 获取卡片的发动效果
	local check=false
	if c:GetOriginalCode()==id-10 then check=true end
	local te=c:CheckActivateEffect(check,false,false)
	if not te then return false end

	-- 必须是伯吉斯异兽陷阱卡且可发动
	if not (c:IsSetCard(0xd4) and c:GetType()==TYPE_TRAP and te:CheckCountLimit(tp) and c:IsFaceupEx()) then
		return false
	end

	-- 模拟发动前的检查
	local con=te:GetCondition()
	local co=te:GetCost()
	local tg=te:GetTarget()

	-- 检查 condition
	if con and not con(te,tp,eg,ep,ev,re,r,rp) then
		return false
	end

	-- 检查 cost（chk=0 模拟支付检查）
	if co and not co(te,tp,eg,ep,ev,re,r,rp,0) then
		return false
	end

	-- 检查 target（chk=0 模拟目标检查）
	if c:IsSetCard(0x95) then
		if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then
			return false
		end
	else
		if tg and not tg(te,tp,eg,ep,ev,re,r,rp,0) then
			return false
		end
	end

	return true
end

-- 目标函数（不取对象，只检查是否存在可发动的卡）
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
end

function s.setop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
    local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
    local tc=g:GetFirst()
    if not tc then return end

    local te=tc:GetActivateEffect()
    local tpe=tc:GetType()
    local con=te:GetCondition()
    local co=te:GetCost()
    local tg=te:GetTarget()
    local op=te:GetOperation()
    e:SetCategory(te:GetCategory())
    e:SetProperty(te:GetProperty())
    Duel.ClearTargetCard()

    -- 移动到场上
    if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS)~=0 or tc:IsHasEffect(EFFECT_REMAIN_FIELD) then
        if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    elseif bit.band(tpe,TYPE_FIELD)~=0 then
        Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
    else
        if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				tc:SetStatus(STATUS_LEAVE_CONFIRMED,true)
    end

    -- 手动注册连锁结束时送墓的效果（仅对通常陷阱等需要送墓的卡）
    if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS)==0 and not tc:IsHasEffect(EFFECT_REMAIN_FIELD) and bit.band(tpe,TYPE_FIELD)==0 then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_CHAIN_END)
        e1:SetLabelObject(tc)
        e1:SetCountLimit(1)
        e1:SetOperation(s.leaveop)
        Duel.RegisterEffect(e1,tp)
    end

    tc:CreateEffectRelation(te)
    if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
    if tg then
        if tc:IsSetCard(0x95) then
            tg(e,tp,eg,ep,ev,re,r,rp,1)
        else
            tg(te,tp,eg,ep,ev,re,r,rp,1)
        end
    end
    Duel.BreakEffect()
    local tgc=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if tgc and #tgc>0 then
        local etc=tgc:GetFirst()
        while etc do
            etc:CreateEffectRelation(te)
            etc=tgc:GetNext()
        end
    end
    if op then
        if tc:IsSetCard(0x95) then
            op(e,tp,eg,ep,ev,re,r,rp)
        else
            op(te,tp,eg,ep,ev,re,r,rp)
        end
    end
    tc:ReleaseEffectRelation(te)
    if tgc and #tgc>0 then
        local etc=tgc:GetFirst()
        while etc do
            etc:ReleaseEffectRelation(te)
            etc=tgc:GetNext()
        end
    end
    te:UseCountLimit(tp,1)
end

-- 连锁结束时送墓的操作
function s.leaveop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if tc and tc:IsLocation(LOCATION_SZONE) and tc:IsFaceup() then
        Duel.SendtoGrave(tc,REASON_RULE)
    end
    e:Reset()
end



function s.repfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField() and not c:IsReason(REASON_REPLACE)
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(s.repfilter,1,nil,tp)
		and c:IsAbleToRemove() and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function s.desrepval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end