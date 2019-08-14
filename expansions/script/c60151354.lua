--天符「释迦牟尼的五行山」
function c60151354.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c60151354.condition)
    e1:SetTarget(c60151354.target)
    e1:SetOperation(c60151354.activate)
    c:RegisterEffect(e1)
	--
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCondition(c60151354.negcon)
    e2:SetCost(c60151354.negcost)
    e2:SetTarget(c60151354.target2)
    e2:SetOperation(c60151354.activate2)
    c:RegisterEffect(e2)
end
function c60151354.ccfilter(c)
    return c:GetOverlayCount()>0 and c:IsType(TYPE_XYZ) and c:IsSetCard(0xcb23)
		and c:GetOverlayGroup():IsExists(c60151354.ccfilter2,1,nil)
end
function c60151354.ccfilter2(c)
    return c:IsSetCard(0xcb23)
end
function c60151354.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c60151354.ccfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c60151354.filter(c)
    return c:IsAbleToHand()
end
function c60151354.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151354.filter,tp,0,LOCATION_SZONE,1,nil) 
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
    local sg=Duel.GetMatchingGroup(c60151354.filter,tp,0,LOCATION_SZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c60151354.filter2(c)
    return c:IsSetCard(0xcb23) and c:IsType(TYPE_MONSTER)
end
function c60151354.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local sg=Duel.GetMatchingGroup(c60151354.filter,tp,0,LOCATION_SZONE,nil)
    if Duel.SendtoHand(sg,nil,REASON_EFFECT) then
		if Duel.GetLocationCount(1-tp,LOCATION_SZONE)<=0 then return end
        local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil,e,tp)
        if g:GetCount()>0 then
            Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151354,0))
            local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			local tc=sg:GetFirst()
			if not tc:IsImmuneToEffect(e) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_SET_ATTACK_FINAL)
				e3:SetValue(0)
				e3:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e3)
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
				e4:SetValue(0)
				e4:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e4)
				local e5=Effect.CreateEffect(c)
				e5:SetDescription(aux.Stringid(60151354,2))
				e5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e5:SetType(EFFECT_TYPE_SINGLE)
				e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
				e5:SetValue(1)
				e5:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e5)
				--
				local e9=Effect.CreateEffect(c)
				e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
				e9:SetCode(EVENT_PRE_BATTLE_DAMAGE)
				e9:SetOperation(c60151354.damop)
				tc:RegisterEffect(e9)
				local ft=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151354,1))
				local sg2=Duel.SelectMatchingCard(tp,c60151354.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,ft,ft,nil)
				local tc2=sg2:GetFirst()
				while tc2 do
					Duel.MoveToField(tc2,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
					Duel.Equip(tp,tc2,tc,false,true)
					local e6=Effect.CreateEffect(e:GetHandler())
					e6:SetType(EFFECT_TYPE_SINGLE)
					e6:SetCode(EFFECT_EQUIP_LIMIT)
					e6:SetReset(RESET_EVENT+0x1fe0000)
					e6:SetValue(1)
					tc2:RegisterEffect(e6)
					local e7=Effect.CreateEffect(e:GetHandler())
					e7:SetDescription(aux.Stringid(60151354,3))
					e7:SetProperty(EFFECT_FLAG_CLIENT_HINT)
					e7:SetType(EFFECT_TYPE_SINGLE)
					e7:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
					e7:SetReset(RESET_EVENT+0x1fe0000)
					e7:SetValue(LOCATION_DECKSHF)
					tc2:RegisterEffect(e7)
					local e8=Effect.CreateEffect(c)
					e8:SetType(EFFECT_TYPE_SINGLE)
					e8:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
					e8:SetValue(1)
					e8:SetReset(RESET_EVENT+0x1fe0000)
					tc2:RegisterEffect(e8)
					tc2=sg2:GetNext()
				end
				Duel.EquipComplete()
			end
        end
	end
end
function c60151354.damcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetBattleTarget()~=nil
end
function c60151354.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(ep,ev/2)
end
function c60151354.negcon(e,tp,eg,ep,ev,re,r,rp)
    return aux.exccon(e) and Duel.GetTurnPlayer()==tp
end
function c60151354.cfilter(c)
    return c:IsType(TYPE_EQUIP) and c:IsAbleToGraveAsCost()
end
function c60151354.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() 
		and Duel.IsExistingMatchingCard(c60151354.cfilter,tp,LOCATION_ONFIELD,0,2,nil) end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c60151354.cfilter,tp,LOCATION_ONFIELD,0,2,2,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c60151354.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c60151354.activate2(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end