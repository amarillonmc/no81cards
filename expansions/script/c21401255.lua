--幻爆术的裁决者
local s,id=GetID()
function s.initial_effect(c)
	--Synchro summon：「幻爆术」调整＋调整以外的怪兽1只以上
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3d71),aux.NonTuner(nil),1)
	c:EnableReviveLimit()

	--①：特殊召唤时宣言属性
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.atttg)
	e1:SetOperation(s.attop)
	c:RegisterEffect(e1)

	--②：対応「从手卡发动」
	local e2a=Effect.CreateEffect(c)
	e2a:SetDescription(aux.Stringid(id,1))
	e2a:SetCategory(CATEGORY_DESTROY)
	e2a:SetType(EFFECT_TYPE_QUICK_O)
	e2a:SetCode(EVENT_CHAINING)
	e2a:SetRange(LOCATION_MZONE)
	e2a:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2a:SetCountLimit(1,id+1)
	e2a:SetCondition(s.descon1)
	e2a:SetCost(s.descost)
	e2a:SetTarget(s.destg)
	e2a:SetOperation(s.desop)
	c:RegisterEffect(e2a)

	--②：対応「从场上发动」
	local e2b=e2a:Clone()
	e2b:SetCountLimit(1,id+2)
	e2b:SetCondition(s.descon2)
	c:RegisterEffect(e2b)

	--②：対応「从墓地发动」
	local e2c=e2a:Clone()
	e2c:SetCountLimit(1,id+3)
	e2c:SetCondition(s.descon3)
	c:RegisterEffect(e2c)

	--③：从场上送去墓地，从卡组把1张「幻爆術」卡加入手卡
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id+4)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end

----------------------------------------------------------------
-- ①
----------------------------------------------------------------
function s.indestg(e,c)
	return c:IsFaceup() and c:IsAttribute(e:GetLabel())
end

function s.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

function s.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--宣言属性（效果处理）
	local att=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL)

	--直到回合结束：宣言属性的自己怪兽不被效果破坏（带文字标注）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.indestg)
	e1:SetLabel(att)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)

	--那之后，可以让这张卡变成宣言的属性
	Duel.BreakEffect()
	if c:IsFaceup() and c:IsRelateToEffect(e)
		and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(att)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e2)
	end
end

----------------------------------------------------------------
-- ②
----------------------------------------------------------------
function s.desconbase(e,tp,eg,ep,ev,re,r,rp,loc)
	if not re then return false end
	local c=e:GetHandler()
	if not c:IsFaceup() then return false end
	if not re:IsActiveType(TYPE_MONSTER) then return false end
	local tloc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if tloc&loc==0 then return false end
	local rc=re:GetHandler()
	if not rc then return false end
	local att=c:GetAttribute()
	if att==0 then return false end
	return rc:IsAttribute(att)
end

function s.descon1(e,tp,eg,ep,ev,re,r,rp)
	return s.desconbase(e,tp,eg,ep,ev,re,r,rp,LOCATION_HAND)
end
function s.descon2(e,tp,eg,ep,ev,re,r,rp)
	return s.desconbase(e,tp,eg,ep,ev,re,r,rp,LOCATION_ONFIELD)
end
function s.descon3(e,tp,eg,ep,ev,re,r,rp)
	return s.desconbase(e,tp,eg,ep,ev,re,r,rp,LOCATION_GRAVE)
end

function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

function s.desfilter(c)
	return c:IsOnField()
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then
		return Duel.IsExistingTarget(s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

----------------------------------------------------------------
-- ③
----------------------------------------------------------------
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.thfilter(c)
	return c:IsSetCard(0x3d71) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
