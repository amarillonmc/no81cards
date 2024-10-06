--渊猎的魔枪

local cid=36000070
local s,id,o=GetID()

function s.initial_effect(c)
    aux.AddCodeList(c,cid)
	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	--equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(s.eqlimit)
	c:RegisterEffect(e2)
	--UpAtk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(300)
	c:RegisterEffect(e3)
	--desrep
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(s.destg)
	e4:SetOperation(s.desop)
	c:RegisterEffect(e4)

    --ToGraveTarget
    local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,id)
	e5:SetCondition(s.togcon)
	e5:SetTarget(s.togtg)
	e5:SetOperation(s.togop)
	c:RegisterEffect(e5)
	
	--EquipFromGrave
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,2))
	e7:SetCategory(CATEGORY_EQUIP+CATEGORY_GRAVE_ACTION)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetCountLimit(1,id+1)
	e7:SetCondition(s.eqgcon)
	e7:SetTarget(s.eqgtg)
	e7:SetOperation(s.eqgop)
	c:RegisterEffect(e7)
	
end

function s.eqlimit(e,c)
	return aux.IsCodeListed(c,cid) 
end
function s.eqfilter(c)
	return c:IsFaceup() and aux.IsCodeListed(c,cid) 
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.eqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end

--e4

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tg=c:GetEquipTarget()
	if chk==0 then return c:IsDestructable() and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
		and tg and tg:IsReason(REASON_BATTLE+REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end

--e5
--ToGraveTarget

function s.togcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_SZONE) and c:IsPreviousPosition(POS_FACEUP)
end

function s.togtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
	
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,LOCATION_ONFIELD)
end

function s.togop(e,tp,eg,ep,ev,re,r,rp)	
	local tc=Duel.GetFirstTarget()
    if not (tc:IsRelateToEffect(e) and tc:IsAbleToGrave()) then return end
    Duel.SendtoGrave(tc,REASON_EFFECT)
end


--e7
--EquipFromGrave

function s.eqgconfilter(c,tp)
    return aux.IsCodeListed(c,cid) and c:IsControler(tp)
end

function s.eqgcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	return eg:IsExists(s.eqgconfilter,1,c,tp)
end

function s.eqsfilter(c)
    return aux.IsCodeListed(c,cid) and c:IsType(TYPE_EQUIP)
    and c:IsFaceupEx()
    and Duel.GetLocationCount(tp,LOCATION_SZONE-LOCATION_FZONE)>0
end

function s.eqmfilter(c)
    return aux.IsCodeListed(c,cid) and c:IsFaceup()
end

function s.eqgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(s.eqsfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.IsExistingMatchingCard(s.eqmfilter,tp,LOCATION_MZONE,0,1,nil) end
   	
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,LOCATION_GRAVE)
end

function s.eqgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    
    if not (Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.eqsfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.IsExistingMatchingCard(s.eqmfilter,tp,LOCATION_MZONE,0,1,nil)) then return end
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local eqsg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.eqsfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local eqmg=Duel.SelectMatchingCard(tp,s.eqmfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Equip(tp,eqsg:GetFirst(),eqmg:GetFirst())
end


