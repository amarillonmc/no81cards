Hata_no_Kokoro={} or Hata_no_Kokoro
Hnk = Hata_no_Kokoro

function Hata_no_Kokoro.eff2(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(Hata_no_Kokoro.recon)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
    e2:SetTarget(Hata_no_Kokoro.indestg)
	c:RegisterEffect(e2)
end
function Hata_no_Kokoro.recon(e)
	return e:GetHandler():IsFaceup()
end
function Hata_no_Kokoro.indestg(e,c,rp,r,re)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP) and c:IsLocation(LOCATION_SZONE) and c:GetEquipTarget()==e:GetHandler()
end
function Hata_no_Kokoro.eff3(c,id,loc)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_DESTROY)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id-1000)
    e1:SetCondition(Hata_no_Kokoro.spcon)
	e1:SetTarget(Hata_no_Kokoro.sptg)
	e1:SetOperation(Hata_no_Kokoro.spop(loc))
	c:RegisterEffect(e1)
end
function Hata_no_Kokoro.defilter(c,tp)
    return c:IsType(TYPE_EQUIP) and c:IsReason(REASON_DESTROY) and c:IsPreviousControler(tp)
end
function Hata_no_Kokoro.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Hata_no_Kokoro.defilter,1,nil,tp)
end
function Hata_no_Kokoro.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_REMOVED)
end
function Hata_no_Kokoro.eqfilter(c,tc,tp)
	if not c:IsType(TYPE_EQUIP) then return false end
    return c:IsSetCard(0x3c10) and c:CheckEquipTarget(tc) and c:CheckUniqueOnField(tp,LOCATION_SZONE) and not c:IsForbidden()
end
function Hata_no_Kokoro.spop(loc)
    return function(e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        if c:IsRelateToEffect(e) then
            if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
                Duel.BreakEffect()
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
				if Duel.IsExistingMatchingCard(Hata_no_Kokoro.eqfilter,tp,loc,0,1,nil,c,tp) then
					local g=Duel.SelectMatchingCard(tp,Hata_no_Kokoro.eqfilter,tp,loc,0,1,1,nil,c,tp)
					local tc2=g:GetFirst()
					Duel.Equip(tp,tc2,c)
				end
            end
        end
    end
end
function Hata_no_Kokoro.hnk_equip(c,id,e)
    c:SetUniqueOnField(1,0,id)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(Hata_no_Kokoro.eqtg)
	e1:SetOperation(Hata_no_Kokoro.eqop)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(Hata_no_Kokoro.eqlimit)
	c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(Hata_no_Kokoro.eftg)
    e3:SetLabelObject(e)
    c:RegisterEffect(e3)
end
function Hata_no_Kokoro.eqlimit(e,c)
	return c:IsSetCard(0x3c10)
end
function Hata_no_Kokoro.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3c10)
end
function Hata_no_Kokoro.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and Hata_no_Kokoro.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(Hata_no_Kokoro.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Hata_no_Kokoro.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function Hata_no_Kokoro.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function Hata_no_Kokoro.anger_eq(c)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function Hata_no_Kokoro.eftg(e,c)
	return e:GetOwner():GetEquipTarget()==c and c:IsSetCard(0x3c10)
end
function Hata_no_Kokoro.efcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(c)
end
function Hata_no_Kokoro.become_target(c,id)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id-1000)
	e1:SetCondition(Hata_no_Kokoro.efcon)
	return e1
end
function Hata_no_Kokoro.worries_eq(c)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetValue(500)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function Hata_no_Kokoro.fun_eq(c)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(Hata_no_Kokoro.efilter)
	c:RegisterEffect(e1)
end
function Hata_no_Kokoro.efilter(e,te)
	if te:GetOwnerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetOwner():GetEquipTarget())
end
function Hata_no_Kokoro.steff2q(c,id)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,id-1000)
	e1:SetTarget(Hata_no_Kokoro.tdtgq)
	e1:SetOperation(Hata_no_Kokoro.tdop)
	c:RegisterEffect(e1)
end
function Hata_no_Kokoro.steff2(c,id)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,id-1000)
	e1:SetTarget(Hata_no_Kokoro.tdtg)
	e1:SetOperation(Hata_no_Kokoro.tdop)
	c:RegisterEffect(e1)
end
function Hata_no_Kokoro.tdfilterq(c)
	return c:IsSetCard(0x3c10) and c:IsType(TYPE_EQUIP) and c:IsAbleToDeck()
end
function Hata_no_Kokoro.tdfilter(c)
	return c:IsSetCard(0x3c10) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function Hata_no_Kokoro.tdtgq(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsSetCard(0x3c10) and chkc:IsAbleToDeck() end
    if chk==0 then return Duel.IsExistingTarget(Hata_no_Kokoro.tdfilterq,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,Hata_no_Kokoro.tdfilterq,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,tp,LOCATION_GRAVE)
end
function Hata_no_Kokoro.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsSetCard(0x3c10) and chkc:IsAbleToDeck() end
    if chk==0 then return Duel.IsExistingTarget(Hata_no_Kokoro.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,Hata_no_Kokoro.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	g:AddCard(e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function Hata_no_Kokoro.tdop(e,tp,eg,ep,ev,re,r,rp)
    local tc =Duel.GetFirstTarget()
	local c=e:GetHandler()
    if tc then
		local g=Group.CreateGroup()
		if tc:IsRelateToEffect(e) then
			g:AddCard(tc)
		end
		if c:IsRelateToEffect(e) then
			g:AddCard(c)
		end
		if #g>0 then
			Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
    end
end
function Hata_no_Kokoro.pbfilter(c)
	return not c:IsPublic()
end
function Hata_no_Kokoro.public(c,id,tp)
	if Duel.IsExistingMatchingCard(Hata_no_Kokoro.pbfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,Hata_no_Kokoro.pbfilter,tp,LOCATION_HAND,0,1,1,nil)
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end