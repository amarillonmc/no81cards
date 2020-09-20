--沙俄皇女·阿纳斯塔西娅
function c9951322.initial_effect(c)
	  c:SetSPSummonOnce(9951322)
	  --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xba5),7,2,c9951322.ovfilter,aux.Stringid(9951322,1))
	c:EnableReviveLimit()
 --material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951322,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c9951322.target)
	e1:SetOperation(c9951322.operation)
	c:RegisterEffect(e1)
--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1)
	e1:SetCondition(c9951322.ngcon)
	e1:SetCost(c9951322.ngcost)
	e1:SetTarget(c9951322.ngtg)
	e1:SetOperation(c9951322.ngop)
	c:RegisterEffect(e1)  
 --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951322.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951322.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951322,0))
Duel.Hint(HINT_SOUND,0,aux.Stringid(9951322,2))
end
function c9951322.ovfilter(c)
	return c:IsFaceup() and c:IsCode(9951321) 
end
function c9951322.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if chk==0 then return tc and c:IsType(TYPE_XYZ) and not tc:IsType(TYPE_TOKEN) and tc:IsAbleToChangeControler() end
end
function c9951322.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToBattle() and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
   Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951322,0))
Duel.Hint(HINT_SOUND,0,aux.Stringid(9951322,3))
end
function c9951322.ngcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp~=tp and re:IsActiveType(TYPE_MONSTER)
		and Duel.IsChainDisablable(ev) and re:GetHandler():IsAbleToChangeControler()
		and not re:GetHandler():IsType(TYPE_TOKEN)
end
function c9951322.ngcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9951322.ngtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c9951322.ngop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) and not rc:IsType(TYPE_TOKEN) and c:IsType(TYPE_XYZ) and c:IsRelateToEffect(e) and c:IsFaceup() then
		local og=rc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(rc))
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951322,0))
Duel.Hint(HINT_SOUND,0,aux.Stringid(9951322,4))
end
