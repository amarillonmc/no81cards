--升阶魔法-袭击之力
function c114514699.initial_effect(c)
    -- ① 效果：以暗属性超量怪兽为对象，特殊召唤阶级高1或2阶的同种族超量怪兽
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c114514699.target1)
    e1:SetOperation(c114514699.operation1)
    c:RegisterEffect(e1)

    -- ② 效果：代替破坏
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c114514699.reptg)
	e2:SetValue(c114514699.repval)
	e2:SetOperation(c114514699.repop)
	c:RegisterEffect(e2)
end

-- ① 效果：目标设置
function c114514699.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c114514699.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c114514699.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

-- ① 效果：执行操作
function c114514699.operation1(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc or not tc:IsRelateToEffect(e) then return end

    -- 如果对象是对方场上的怪兽，先获得控制权
    if tc:IsControler(1-tp) then
        Duel.GetControl(tc,tp,PHASE_END,1)
    end

    local race=tc:GetRace()
    local rk=tc:GetRank()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c114514699.filter2,tp,LOCATION_EXTRA,0,1,1,nil,race,rk)
    local sc=g:GetFirst()
    if sc then
        -- 将对象怪兽作为超量素材
        local mg=tc:GetOverlayGroup()
        if mg:GetCount()>0 then
            Duel.Overlay(sc,mg)
        end
        Duel.Overlay(sc,Group.FromCards(tc))
        -- 特殊召唤
        Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
        sc:CompleteProcedure()
    end
end

-- ① 效果：过滤函数1（选择暗属性超量怪兽）
function c114514699.filter1(c,tp)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_XYZ)
        and Duel.IsExistingMatchingCard(c114514699.filter2,tp,LOCATION_EXTRA,0,1,nil,c:GetRace(),c:GetRank())
end

-- ① 效果：过滤函数2（选择阶级高1或2阶的同种族超量怪兽）
function c114514699.filter2(c,race,rk)
    return c:IsRace(race) and c:IsType(TYPE_XYZ) and (c:GetRank()==rk+1 or c:GetRank()==rk+2)
end


function c114514699.repfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c114514699.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c114514699.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c114514699.repval(e,c)
	return c114514699.repfilter(c,e:GetHandlerPlayer())
end
function c114514699.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end