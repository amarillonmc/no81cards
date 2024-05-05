--红锈魔纹

local id=32000230
local zd=0xff6
function c32000230.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c32000230.e1tg)
	e1:SetOperation(c32000230.e1op)
	c:RegisterEffect(e1)
   --Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
    --DestoryAndRemoveThen
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DESTROYED)
    e3:SetCountLimit(1,id+1+EFFECT_COUNT_CODE_OATH)
	e3:SetTarget(c32000230.e3tg)
	e3:SetOperation(c32000230.e3op)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
end

--e1
function c32000230.e1eqfilter(c)
	return c:IsFaceup()
end
function c32000230.e1desfilter(c)
    return c:IsDestructable() and c:IsSetCard(zd)
end
function c32000230.e1spfilter(c,e,tp)
	return c:IsSetCard(zd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c32000230.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)

	if chk==0 then return Duel.IsExistingMatchingCard(c32000210.e1spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c32000230.e1desfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end

function c32000230.e1op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not (Duel.IsExistingMatchingCard(c32000230.e1desfilter,tp,LOCATION_ONFIELD,0,1,c)) then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c32000230.e1desfilter,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.Destroy(g,REASON_EFFECT)
	
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c32000210.e1spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
     
     Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	 local g3=Duel.SelectMatchingCard(tp,c32000230.e1eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	 Duel.Equip(tp,c,g3:GetFirst())

end

--e3

function c32000230.e3setfilter(c)
	return c:IsSetCard(zd) and c:IsType(TYPE_FIELD)
end

function c32000230.e3todfilter(c,e,tp)
	return c:IsSetCard(zd) and c:IsAbleToDeck() and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end

function c32000230.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32000230.e3setfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
end

function c32000230.e3op(e,tp,eg,ep,ev,re,r,rp)
    if not (Duel.IsExistingMatchingCard(c32000230.e3setfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil)) then return end
    local g=Duel.SelectMatchingCard(tp,c32000230.e3setfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
    Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_FZONE,POS_FACEUP,true)
    
    if not (Duel.IsExistingMatchingCard(c32000230.e3todfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,HINTMSG_TODECK))
	then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,c32000230.e3todfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,8,nil)
	Duel.SendtoDeck(g2,tp,1,REASON_EFFECT)
end







