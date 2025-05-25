function c10111191.initial_effect(c)
	--summon with 1 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10111191,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c10111191.otcon)
	e1:SetOperation(c10111191.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	--tribute summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10111191,1))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,10111191)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCondition(c10111191.sumcon)
	e3:SetTarget(c10111191.sumtg)
	e3:SetOperation(c10111191.sumop)
	c:RegisterEffect(e3)
   -- 召唤成功时效果
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(10111191,0))
    e4:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_SUMMON_SUCCESS)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetTarget(c10111191.tg)
    e4:SetOperation(c10111191.op)
    c:RegisterEffect(e4)
    
    -- 素材检查效果
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_MATERIAL_CHECK)
    e5:SetValue(c10111191.valcheck)
    e5:SetLabelObject(e4)
    c:RegisterEffect(e5)
end
function c10111191.rfilter(c,tp)
	return c:IsRace(RACE_DINOSAUR) and (c:IsControler(tp) or c:IsFaceup())
end
function c10111191.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c10111191.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c10111191.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c10111191.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c10111191.cfilter(c)
	return c:IsRace(RACE_DINOSAUR) and c:IsFaceup()
end
function c10111191.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10111191.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c10111191.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function c10111191.sumop(e,tp,eg,ep,ev,re,r,rp)
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

-- 素材检查（保持不变）
function c10111191.valcheck(e,c)
    local g=c:GetMaterial()
    if g:IsExists(Card.IsSetCard,1,nil,0x1185) then
        e:GetLabelObject():SetLabel(1)
    else
        e:GetLabelObject():SetLabel(0)
    end
end

-- 目标选择
function c10111191.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_SZONE+LOCATION_GRAVE,1,nil) 
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_SZONE+LOCATION_GRAVE,1,1,nil)
    if #g>0 then
        e:SetLabelObject(g:GetFirst())
        if e:GetLabel()==1 then
            Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
        else
            Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
        end
    end
end

-- 效果处理
function c10111191.op(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if not tc or not tc:IsLocation(LOCATION_SZONE+LOCATION_GRAVE) then return end
    
    local replace=(e:GetLabel()==1)
    
    if replace then
        if Duel.SendtoHand(tc,tp,REASON_EFFECT)~=0 then
            Duel.ConfirmCards(1-tp,tc)
        end
    else
        Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
    end
end