--Legend-Arms 斯巴达兽
function c16310080.initial_effect(c)
	c16310080.EnableUnionAttribute(c,c16310080.unfilter)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,16310080)
	e2:SetTarget(c16310080.eqtg)
	e2:SetOperation(c16310080.eqop)
	c:RegisterEffect(e2)
	local e22=e2:Clone()
	e22:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e22)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,16310080+1)
	e3:SetCondition(c16310080.drcon)
	e3:SetTarget(c16310080.drtg)
	e3:SetOperation(c16310080.drop)
	c:RegisterEffect(e3)
end
function c16310080.eqfilter(c,ec)
	return c:IsSetCard(0x3dc6) and c:IsType(0x1) and not c:IsForbidden()
end
function c16310080.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c16310080.eqfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c16310080.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)==0 then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsFaceup()
		and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c16310080.eqfilter,tp,LOCATION_DECK,0,1,1,nil,c)
		if g:GetCount()>0 then
			Duel.Equip(tp,g:GetFirst(),c)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c16310080.eqlimit)
			e1:SetLabelObject(c)
			g:GetFirst():RegisterEffect(e1)
		end
	end
end
function c16310080.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c16310080.drcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	return Duel.GetAttacker()==tc or Duel.GetAttackTarget()==tc
end
function c16310080.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c16310080.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c16310080.unfilter(c)
	return c:IsSetCard(0x3dc6)
end
function c16310080.EnableUnionAttribute(c,filter)
	local equip_limit=Auxiliary.UnionEquipLimit(filter)
	--destroy sub
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e1:SetValue(Auxiliary.UnionReplaceFilter)
	c:RegisterEffect(e1)
	--limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UNION_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(equip_limit)
	c:RegisterEffect(e2)
	--equip
	local equip_filter=Auxiliary.UnionEquipFilter(filter)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(1068)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetTarget(Auxiliary.UnionEquipTarget(equip_filter))
	e3:SetOperation(Auxiliary.UnionEquipOperation(equip_filter))
	c:RegisterEffect(e3)
	--unequip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(1152)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetHintTiming(0,TIMING_MAIN_END)
	e4:SetTarget(Auxiliary.UnionUnequipTarget)
	e4:SetOperation(Auxiliary.UnionUnequipOperation)
	c:RegisterEffect(e4)
end