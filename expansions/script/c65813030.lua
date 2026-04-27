--防御阵线 要塞
local s,id,o=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	c:EnableReviveLimit()
--==== 自定义连接召唤手续 ====--
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(1166)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(s.lkcon)
    e1:SetTarget(s.lktg)
    e1:SetOperation(s.lkop)
    e1:SetValue(SUMMON_TYPE_LINK)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.descost)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,4))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(s.tscon)
	e3:SetTarget(s.tstg)
	e3:SetOperation(s.tsop)
	c:RegisterEffect(e3)
end

--============ 连接素材条件 ============
-- 场上符合条件的怪兽：原本种类包含陷阱
function s.matfilter(c)
    return c:GetOriginalType()&TYPE_TRAP>0
end

-- 手卡防御阵线卡（不要求怪兽）
function s.handfilter(c)
    return c:IsSetCard(0x5a31)
end

--============ 连接值计算函数 ============
-- 复制 procedure.lua 中的 GetLinkCount，但对手卡防御阵线卡（非怪兽）直接返回1
function s.GetLinkCount(c,lc)
    -- 如果是手卡的防御阵线卡，且它不可能是连接怪兽，直接当作1个素材
    if c:IsLocation(LOCATION_HAND) and c:IsSetCard(0x5a31) and not c:IsType(TYPE_LINK) then
        return 1
    end
    -- 否则调用引擎原生计算（场上怪兽、或是手卡连接怪兽等）
    if c:IsType(TYPE_LINK) and c:GetLink()>1 then
        return 1+0x10000*c:GetLink()
    else
        return 1
    end
end

--============ 素材组筛选函数 ============
-- 把场上怪兽和手卡防御阵线卡合并（过滤掉不符合基本条件的卡）
function s.GetLinkMaterials(tp,lc)
    local mg1=Duel.GetMatchingGroup(s.MonFilter,tp,LOCATION_MZONE,0,nil,lc)
    local mg2=Duel.GetMatchingGroup(s.HandFilter,tp,LOCATION_HAND,0,nil,lc)
    if mg2:GetCount()>0 then mg1:Merge(mg2) end
    return mg1
end

-- 场上怪兽过滤：满足 matfilter 且能作为连接素材
function s.MonFilter(c,lc)
    return c:IsFaceup() and s.matfilter(c) and c:IsCanBeLinkMaterial(lc)
end

-- 手卡防御阵线卡过滤：不检查 IsCanBeLinkMaterial，只要求是防御阵线卡且未被禁止
-- 注意：魔陷卡不能通常作为素材，但我们这里直接放行，引擎会在正式召唤时接受（因为是由效果特殊召唤）
function s.HandFilter(c,lc)
    return s.handfilter(c) and not c:IsForbidden()
end

--============ 素材组合检查 ============
-- 参数 g 是要检查的一组卡
function s.LCheckGoal(g, tp, lc)
    local sum = 0
    for tc in aux.Next(g) do
        sum = sum + s.GetLinkCount(tc, lc)
    end
    if sum ~= lc:GetLink() then return false end
    if Duel.GetLocationCountFromEx(tp, tp, g, lc) <= 0 then return false end
    if not Auxiliary.MustMaterialCheck(g, tp, EFFECT_MUST_BE_LMATERIAL) then return false end
    return true
end

--============ 连接召唤手续：Condition ============
function s.lkcon(e,c,og,lmat,min,max)
    if c==nil then return true end
    if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
    local tp=c:GetControler()
    local minc=2
    local maxc=2
    if min then
        if min>minc then minc=min end
        if max<maxc then maxc=max end
        if minc>maxc then return false end
    end
    local mg=s.GetLinkMaterials(tp,c)
    if lmat~=nil then
        if not mg:IsContains(lmat) then return false end
        Duel.SetSelectedCard(Group.FromCards(lmat))
    end
    return mg:CheckSubGroup(s.LCheckGoal,minc,maxc,tp,c)
end

--============ 连接召唤手续：Target ============
function s.lktg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
    local minc=2
    local maxc=2
    if min then
        if min>minc then minc=min end
        if max<maxc then maxc=max end
    end
    local mg=s.GetLinkMaterials(tp,c)
    if lmat~=nil then
        if not mg:IsContains(lmat) then return false end
        Duel.SetSelectedCard(Group.FromCards(lmat))
    end
    local cancel=Duel.IsSummonCancelable()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
    local sg=mg:SelectSubGroup(tp,s.LCheckGoal,cancel,minc,maxc,tp,c)
    if sg then
        sg:KeepAlive()
        e:SetLabelObject(sg)
        return true
    else
        return false
    end
end

--============ 连接召唤手续：Operation ============
function s.lkop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
    local g=e:GetLabelObject()
    c:SetMaterial(g)
    -- 将素材送去墓地（连接召唤的通用处理）
    Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
    g:DeleteGroup()
end

function s.cfilter(c)
	return c:IsSetCard(0x5a31) and c:IsSSetable() and c:IsType(TYPE_TRAP) and c:IsFaceupEx()
end
function s.filter1(c)
	return c:IsSetCard(0x5a31) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToHandAsCost()
end
function s.filter2(c)
	return c:IsSetCard(0x5a31) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToDeckAsCost()
end
function s.filter3(c)
	return c:IsSetCard(0x5a31) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function s.filter4(c)
	return c:IsSetCard(0x5a31) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToRemoveAsCost()
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_MZONE,0,1,c) and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_MZONE,0,1,c) and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_DECK,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_MZONE,0,1,c) and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil)
	local b4=Duel.IsExistingMatchingCard(s.filter4,tp,LOCATION_MZONE,0,1,c) and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_REMOVED,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)},
		{b3,aux.Stringid(id,2)},
		{b4,aux.Stringid(id,3)})
	e:SetLabel(op)
	if op==1 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_MZONE,0,1,1,c)
		Duel.SendtoHand(g,nil,REASON_COST)
	elseif op==2 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_MZONE,0,1,1,c)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
	elseif op==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.filter3,tp,LOCATION_MZONE,0,1,1,c)
		Duel.SendtoGrave(g,REASON_COST)
	elseif op==4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,s.filter4,tp,LOCATION_MZONE,0,1,1,c)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	else end
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g)
		end
	elseif sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g)
		end
	elseif sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g)
		end
	elseif sel==4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_REMOVED,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g)
		end
	else end
end

function s.tscon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return rp==tp and r&REASON_COST>0
		and (rc:IsSetCard(0x5a31) and rc:IsType(TYPE_TRAP))
end
function s.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.tsop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(s.desop2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x5a31) and c:IsAbleToHand()
end
function s.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end