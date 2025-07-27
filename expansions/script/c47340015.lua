--旅界者-偶遇
local s,id=GetID()
function s.initial_effect(c)
    s.sprule(c)
    s.eff1(c)
    s.replace(c)
end
function s.sprule(c)
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),7,2,nil,nil,99)
	c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end

function s.eff1(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,1))
    e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE+CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(s.cost)
    e1:SetTarget(s.tetg)
    e1:SetOperation(s.teop)
    c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    local ct=e:GetHandler():GetOverlayCount()
	local rt=e:GetHandler():RemoveOverlayCard(tp,1,math.min(ct,4),REASON_COST)
    e:SetLabel(rt)
end
function s.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_MZONE) and c:IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,tp,LOCATION_MZONE)
end
function s.filter1(c,e,tp)
    return c:IsSetCard(0xac12) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.filter2(c)
    return c:IsSetCard(0xac12) and c:IsAbleToRemove()
end
function s.filter3(c)
    return c:IsType(TYPE_FIELD) and c:IsAbleToDeck()
end
function s.filter4(c)
    return  c:IsAbleToRemove()
end
function s.build_option(b1,b2,b3,b4)
    local off=1
    local ops,opval={},{}
    if b1 then
        ops[off]=aux.Stringid(47340015,2)
        opval[off]=1
        off=off+1
    end
    if b2 then
        ops[off]=aux.Stringid(47340015,3)
        opval[off]=2
        off=off+1
    end
    if b3 then
        ops[off]=aux.Stringid(47340015,4)
        opval[off]=3
        off=off+1
    end
    if b4 then
        ops[off]=aux.Stringid(47340015,5)
        opval[off]=4
        off=off+1
    end
    ops[off]=aux.Stringid(47340015,6)
    opval[off]=5
    return ops,opval
end
function s.teop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
    end
    local rg=Duel.GetOperatedGroup()
    if #rg<=0 then return end
    local act=e:GetLabel()
    local i=0
    local un_sel={true,true,true,true}
    while i<act do
        local b1=Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0
        local b2=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_GRAVE,0,1,nil)
        local b3=Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
        local b4=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter4),tp,0,LOCATION_GRAVE,1,nil)
        local ops,opval=s.build_option(b1 and un_sel[1],b2 and un_sel[2],b3 and un_sel[3],b4 and un_sel[4])

        local op=Duel.SelectOption(tp,table.unpack(ops))+1
        local sel=opval[op]
        if sel==5 then break end
        un_sel[sel]=false
        if sel==1 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        elseif sel==2 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
            local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
            Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
        elseif sel==3 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
            local g=Duel.SelectMatchingCard(tp,s.filter3,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
            Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
        elseif sel==4 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
            local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter4),tp,0,LOCATION_GRAVE,1,1,nil)
            Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
        end
        i=i+1
    end
end

function s.replace(c)
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	c:RegisterEffect(e2)
end
function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsOnField() and c:IsSetCard(0xac12) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function s.ovfilter(c)
    return c:IsType(TYPE_FIELD) and c:IsCanOverlay()
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(s.ovfilter,tp,LOCATION_GRAVE,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
        local g=Duel.SelectMatchingCard(tp,s.ovfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		return true
	end
	return false
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end