--灵式装置 火加具土命
function c9910021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c9910021.target)
	e1:SetOperation(c9910021.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c9910021.eqlimit)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetCountLimit(1)
	e3:SetValue(c9910021.valcon)
	c:RegisterEffect(e3)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_EQUIP)
	e9:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e9:SetCountLimit(1)
	e9:SetValue(c9910021.valcon)
	c:RegisterEffect(e9)
	--disable mzone
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c9910021.mdisable)
	e4:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e4)
	--disable szone
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DISABLE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e5:SetTarget(c9910021.distg)
	c:RegisterEffect(e5)
	--disable szone effect
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVING)
	e6:SetRange(LOCATION_SZONE)
	e6:SetOperation(c9910021.disop)
	c:RegisterEffect(e6)
	--disable trap monster
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e7:SetRange(LOCATION_SZONE)
	e7:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e7:SetTarget(c9910021.distg)
	c:RegisterEffect(e7)
	--to hand
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(9910021,0))
	e8:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_GRAVE)
	e8:SetCountLimit(1,9910021)
	e8:SetCondition(aux.exccon)
	e8:SetCost(aux.bfgcost)
	e8:SetTarget(c9910021.thtg)
	e8:SetOperation(c9910021.thop)
	c:RegisterEffect(e8)
end
function c9910021.eqlimit(e,c)
	return c:IsRace(RACE_WARRIOR) and c:GetSummonLocation()==LOCATION_EXTRA
end
function c9910021.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:GetSummonLocation()==LOCATION_EXTRA
end
function c9910021.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c9910021.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910021.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c9910021.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c9910021.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c9910021.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c9910021.mdisable(e,c)
	local seq=e:GetHandler():GetSequence()
	local tp=e:GetHandlerPlayer()
	return (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT)
		and aux.GetColumn(c,tp)==seq and c~=e:GetHandler():GetEquipTarget()
		and c:GetSequence()<5
end
function c9910021.distg(e,c)
	local ec=e:GetHandler()
	if c==ec or ec:GetCardTargetCount()==0 then return false end
	local eq=ec:GetEquipTarget()
	local tseq=eq:GetSequence()
	tseq=Auxiliary.MZoneSequence(tseq)
	local tp=e:GetHandlerPlayer()
	if 1-tp==ec:GetEquipTarget():GetControler() then tseq=4-tseq end
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
		and aux.GetColumn(c,tp)==tseq
end
function c9910021.disop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	if not ec:GetEquipTarget() then return end
	local tseq=ec:GetEquipTarget():GetSequence()
	tseq=Auxiliary.MZoneSequence(tseq)
	if 1-tp==ec:GetEquipTarget():GetControler() then tseq=4-tseq end
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if loc&LOCATION_SZONE~=0 and seq<=4 and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re~=e:GetHandler()
		and ((rp==tp and seq==tseq) or (rp==1-tp and seq==4-tseq)) then
		Duel.NegateEffect(ev)
	end
end
function c9910021.thfilter(c)
	return c:IsSetCard(0x5950) and not c:IsCode(9910021) and c:IsAbleToHand()
end
function c9910021.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910021.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910021.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910021.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
