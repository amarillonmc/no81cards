function c10111180.initial_effect(c)
	--summon with 1 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10111180,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c10111180.otcon)
	e1:SetOperation(c10111180.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	--tribute summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10111180,1))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,10111180)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCondition(c10111180.sumcon)
	e3:SetTarget(c10111180.sumtg)
	e3:SetOperation(c10111180.sumop)
	c:RegisterEffect(e3)
    -- 统一效果入口
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(10111180,2))
    e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_SUMMON_SUCCESS)
    e4:SetTarget(c10111180.combtg)
    e4:SetOperation(c10111180.combop)
    c:RegisterEffect(e4)
    
    -- 材料检查(核心修正点)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_MATERIAL_CHECK)
    e5:SetValue(c10111180.valcheck)
    e5:SetLabelObject(e4)
    c:RegisterEffect(e5)
end
function c10111180.rfilter(c,tp)
	return c:IsRace(RACE_DINOSAUR) and (c:IsControler(tp) or c:IsFaceup())
end
function c10111180.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c10111180.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c10111180.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c10111180.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c10111180.cfilter(c)
	return c:IsRace(RACE_DINOSAUR) and c:IsFaceup()
end
function c10111180.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10111180.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c10111180.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function c10111180.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local pos=0
	if c:IsSummonable(true,nil,1) then pos=pos+POS_FACEUP_ATTACK end
	if c:IsMSetable(true,nil,1) then pos=pos+POS_FACEDOWN_DEFENSE end
	if pos==0 then return end
	if Duel.SelectPosition(tp,c,pos)==POS_FACEUP_ATTACK then
		Duel.Summon(tp,c,true,nil,1)
	else
		Duel.MSet(tp,c,true,nil,1)
	end
end
-- 材料验证函数
function c10111180.valcheck(e,c)
    local g=c:GetMaterial()
    if g:IsExists(Card.IsSetCard,1,nil,0x1185) then -- 涂鸦兽字段(0x1185)
        e:GetLabelObject():SetLabel(1)
    else
        e:GetLabelObject():SetLabel(0)
    end
end

-- 统一目标设置
function c10111180.combtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    -- 伤害计算
    local dam_ct=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND+LOCATION_ONFIELD,0)
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(dam_ct*300)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam_ct*300)
    
    -- 预载检索标记
    if e:GetLabel()==1 then
        Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    end
end

-- 统一操作处理
function c10111180.combop(e,tp,eg,ep,ev,re,r,rp)
    -- 处理伤害
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local dam_ct=Duel.GetFieldGroupCount(p,LOCATION_HAND+LOCATION_ONFIELD,0)
    if dam_ct>0 then
        Duel.Damage(p,dam_ct*300,REASON_EFFECT)
    end
    
    -- 处理检索(根据材料检查结果)
    if e:GetLabel()==1 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,c10111180.thfilter,tp,LOCATION_DECK,0,1,1,nil)
        if #g>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
end

-- 检索过滤器
function c10111180.thfilter(c)
    return c:IsSetCard(0x185) and c:IsAbleToHand() -- 涂鸦字段(0x185)
end