--梅加特伦驱动进击
function c37730091.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--attack up-other
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c37730091.atktg)--FilterBoolFunction
	e1:SetValue(1500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(37730091,0))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,37730091)
	e3:SetTarget(c37730091.tgtg)
	e3:SetOperation(c37730091.tgop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(37730091,1))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c37730091.eqtg)
	e4:SetOperation(c37730091.eqop)
	c:RegisterEffect(e4)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,37730091+1)
	e5:SetCondition(c37730091.drcon)
	e5:SetCost(aux.bfgcost)
	e5:SetTarget(c37730091.drtg)
	e5:SetOperation(c37730091.drop)
	c:RegisterEffect(e5)
end
function c37730091.cfilter(c)
	return c:IsSetCard(0x2af) and c:IsFaceup()
end
function c37730091.atktg(e,c)
	return c:GetEquipGroup():IsExists(c37730091.cfilter,1,nil)
end
function c37730091.tgfilter(c)
	return c:IsSetCard(0x2af) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c37730091.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37730091.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c37730091.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c37730091.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c37730091.tfilter(c,tp)
	return c:IsSetCard(0x2af) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx() and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c37730091.eqfilter(c)
	return c:IsSetCard(0x2af) and c:IsFaceup()
end
function c37730091.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c37730091.tfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c37730091.tfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) and Duel.IsExistingMatchingCard(c37730091.eqfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c37730091.tfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp)
end
function c37730091.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sc=Duel.SelectMatchingCard(tp,c37730091.eqfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
		if sc and Duel.Equip(tp,tc,sc) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(sc)
			e1:SetValue(c37730091.eqlimit)
			tc:RegisterEffect(e1)
		end
	end
end
function c37730091.eqlimit(e,c)
	return e:GetLabelObject()==c
end
function c37730091.chkfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsFaceup()
end
function c37730091.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c37730091.chkfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c37730091.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c37730091.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)--Duel.Draw(tp,1,REASON_EFFECT)
end
