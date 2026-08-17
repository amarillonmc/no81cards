--凄陌寒昼·长夜归息
local s,id,o=GetID()
function s.initial_effect(c)
    --①效果：诱发必发，怪兽从场上离开时发动
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,1))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_LEAVE_FIELD)
    e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCondition(s.leavecon)
    e1:SetTarget(s.leavetg)
    e1:SetOperation(s.leaveop)
    c:RegisterEffect(e1)

    --②效果：上级召唤时可以从卡组解放本家卡
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.sumcon)
	e2:SetOperation(s.sumop)
	e2:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e2)

    --③效果：这张卡自身获得代破/代除外
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetTarget(s.reptg)
	c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EFFECT_SEND_REPLACE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTarget(s.rmreptg)
    e4:SetValue(s.rmrepval)
    e4:SetOperation(s.rmrepop)
    c:RegisterEffect(e4)

    --③效果：仪式召唤成功时给仪式怪兽附加代破/代除外
    local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_EVENT_PLAYER)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetCondition(s.condition)
	e5:SetOperation(s.operation)
    c:RegisterEffect(e5)
end

function s.sumcon(e,c,minc)
	if c==nil then return true end
	local mi,ma=c:GetTributeRequirement()
	if mi<minc then mi=minc end
	if ma<mi then return false end
	return ma>0 and mi>0 and Duel.GetMatchingGroupCount(s.tgfilter2,c:GetControler(),LOCATION_DECK,0,nil)>=1 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp,c,minc)
	local mi,ma=c:GetTributeRequirement()
	if mi<minc then mi=minc end
	if ma<mi or mi<=0 then return false end
	local tp=c:GetControler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local mg=Duel.SelectMatchingCard(tp,s.tgfilter2,tp,LOCATION_DECK,0,1,1,nil)
	c:SetMaterial(mg)
	Duel.SendtoGrave(mg,REASON_SUMMON+REASON_MATERIAL+REASON_RELEASE)
end


function s.leavecon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_MZONE)
end
--①效果target
function s.leavetg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local c=e:GetHandler()
    if Duel.GetFlagEffect(tp,id)>=3 then
        e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
        Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
    end
end

--①效果操作
function s.leaveop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    --解放卡组最上面
    if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then
        local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
        if tc then
            Duel.SendtoGrave(tc,REASON_RELEASE)
            --解放的是怪兽就注册标识
            if tc:IsType(TYPE_MONSTER) then
                Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
            end
        end
    end
    --标识≥3时检索
    if Duel.GetFlagEffect(tp,id)>=3 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
        if #g>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
end

function s.thfilter(c)
    return c:IsSetCard(0x3f15) and c:IsAbleToHand() and c:IsFaceupEx()
end

--②效果：自定义解放filter
function s.releasefilter(c,tp)
    local re=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)
    if re then
        local val=re:GetValue()
        if val and val(re,c) then return false end
    end
    return true
end


--③效果仪式召唤成功
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL and not e:GetHandler():IsPreviousLocation(LOCATION_OVERLAY)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local rc=eg:GetFirst()
	while rc do
		if rc:GetFlagEffect(id)==0 then
		--untargetable
		local e3=Effect.CreateEffect(c)
        e3:SetDescription(aux.Stringid(id,0))
	    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
    	e3:SetRange(LOCATION_MZONE)
    	e3:SetCode(EFFECT_DESTROY_REPLACE)
    	e3:SetTarget(s.reptg)
	    rc:RegisterEffect(e3)
        local e4=Effect.CreateEffect(c)
        e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
        e4:SetCode(EFFECT_SEND_REPLACE)
        e4:SetRange(LOCATION_MZONE)
        e4:SetTarget(s.rmreptg)
        e4:SetValue(s.rmrepval)
        e4:SetOperation(s.rmrepop)
        rc:RegisterEffect(e4)
		end
		rc=eg:GetNext()
	end
end

--代破/代除外通用
function s.repfilter(c,tp)
    return c:IsSetCard(0x3f15)
end

function s.tgfilter2(c)
    return c:IsSetCard(0x3f15) and s.releasefilter(c,c:GetControler())
end

--破坏代替
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(s.tgfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,s.tgfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c)
		Duel.SendtoGrave(g,REASON_RELEASE+REASON_REPLACE)
		return true
	else return false end
end

--除外代替
function s.rmrepfilter(c,tp)
    return c:IsControler(tp) and c:GetDestination()==LOCATION_REMOVED and not c:IsReason(REASON_REPLACE)
end
function s.rmreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return eg:IsContains(c) and s.rmrepfilter(c,tp)
        and Duel.IsExistingMatchingCard(s.tgfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c) end
    if Duel.SelectEffectYesNo(tp,c,96) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,s.tgfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c)
    if #g>0 then
        g:KeepAlive()
        e:SetLabelObject(g)
        return true
    end
    else return false end
end
function s.rmrepval(e,c)
    return s.rmrepfilter(c,e:GetHandlerPlayer())
end
function s.rmrepop(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetLabelObject()
    Duel.SendtoGrave(g,REASON_RELEASE+REASON_REPLACE)
    g:DeleteGroup()
end