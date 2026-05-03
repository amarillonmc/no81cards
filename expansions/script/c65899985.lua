--厨卡之力 阿冉
local s,id,o=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,s.ffilter,2,true)
    aux.AddContactFusionProcedure(c,s.spfilter,LOCATION_HAND,0,Duel.SendtoGrave,REASON_COST+REASON_DISCARD)
    c:SetSPSummonOnce(id)
    -- ①效果：特殊召唤时，以墓地/除外的1张陷阱卡为对象，加入手卡或盖放
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SSET+CATEGORY_GRAVE_ACTION)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetTarget(s.tg)
    e2:SetOperation(s.op)
    c:RegisterEffect(e2)
end

function s.ffilter(c)
    return c:IsFusionType(TYPE_TRAP) 
end
-- 自身特殊召唤的素材过滤：手卡的陷阱卡，可丢弃
function s.spfilter(c)
    return c:IsType(TYPE_TRAP) and c:IsDiscardable()
end

-- ①效果的目标过滤：自己墓地/除外陷阱，且能加入手卡或能盖放
function s.thfilter(c,e,tp)
    return c:IsType(TYPE_TRAP) and c:IsFaceupEx()
        and (c:IsAbleToHand() or c:IsSSetable())
end

-- ①目标
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and s.thfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
    local g=Duel.SelectTarget(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
end

-- ①操作
function s.op(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) then return end
		if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc)
		end
end