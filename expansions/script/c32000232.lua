--红锈爆裂

local id=32000232
local zd=0xff6
function c32000232.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(c32000232.e1tg)
	e1:SetOperation(c32000232.e1op)
	c:RegisterEffect(e1)
	
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c32000232.e2con)
	c:RegisterEffect(e2)
	
	--GraveToHand
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,id)
	e3:SetCondition(c32000232.e3con)
	e3:SetTarget(c32000232.e3tg)
	e3:SetOperation(c32000232.e3op)
	c:RegisterEffect(e3)
end

--e1
function c32000232.e1desfilter(c)
	return c:IsDestructable()
end

function c32000232.e1des2filter(c)
	return  c:IsSetCard(zd) and c:IsFaceup() and c:IsDestructable()
end

function c32000232.e1tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c32000232.e1desfilter,tp,0,LOCATION_ONFIELD,2,nil) and  Duel.IsExistingTarget(c32000232.e1des2filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c32000232.e1desfilter,tp,0,LOCATION_ONFIELD,2,2,nil)
	local g2=Duel.SelectTarget(tp,c32000232.e1des2filter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	g:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c32000232.e1op(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)  
	Duel.Destroy(g,REASON_EFFECT)
end

--e2

function c32000232.e2con(e,tp,eg,ep,ev,re,r,rp)
    return true
end

--e3
function c32000232.e3confilter(c,e)
	return c:IsFaceup() and c:IsSetCard(zd)
end

function c32000232.e3con(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c32000232.e3confilter,1,nil,tp)
end

function c32000232.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
end
function c32000232.e3op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsAbleToHand() then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end


