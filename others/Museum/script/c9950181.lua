--fate·达·芬奇-灵基再临
function c9950181.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xba5),2)
	c:EnableReviveLimit()
	--cannot battle target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c9950181.btcon)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
	--indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c9950181.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--move
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c9950181.seqtg)
	e3:SetOperation(c9950181.seqop)
	c:RegisterEffect(e3)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9950181.atkval)
	c:RegisterEffect(e1)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950181,0))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9950181.negcon)
	e3:SetTarget(c9950181.negtg)
	e3:SetOperation(c9950181.negop)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950181.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950181.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950181,0))
end
function c9950181.atkval(e,c)
	local g=e:GetHandler():GetLinkedGroup():Filter(Card.IsFaceup,nil)
	return g:GetSum(Card.GetBaseAttack)
end
function c9950181.btfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xba5)
end
function c9950181.btcon(e)
	return e:GetHandler():GetLinkedGroup():IsExists(c9950181.btfilter,1,nil)
end
function c9950181.lkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xba5)
end
function c9950181.indcon(e)
	return e:GetHandler():GetLinkedGroup():IsExists(c9950181.lkfilter,1,nil)
end
function c9950181.seqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xba5) and c:GetSequence()<5 and not c:IsCode(9950181)
end
function c9950181.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9950181.seqfilter(chkc) end
	if chk==0 then
		local zone=bit.band(e:GetHandler():GetLinkedZone(),0x1f)
		return Duel.IsExistingTarget(c9950181.seqfilter,tp,LOCATION_MZONE,0,1,nil)
			and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL,zone)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9950181,1))
	Duel.SelectTarget(tp,c9950181.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9950181.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local zone=bit.band(e:GetHandler():GetLinkedZone(),0x1f)
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp)
		or Duel.GetLocationCount(p,LOCATION_MZONE,p,LOCATION_REASON_CONTROL,zone)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local flag=bit.bxor(zone,0xff)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950181,0))
end
function c9950181.negfilter(c,g)
	return g:IsContains(c)
end
function c9950181.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local lg=e:GetHandler():GetLinkedGroup()
	lg:AddCard(c)
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and lg:IsExists(c9950181.negfilter,1,nil,tg) and Duel.IsChainNegatable(ev)
end
function c9950181.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c9950181.negop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c:IsFacedown() or c:GetAttack()<500 or not c:IsRelateToEffect(e)
		or Duel.GetCurrentChain()~=ev+1 or c:IsStatus(STATUS_BATTLE_DESTROYED) then
		return
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-500)
	c:RegisterEffect(e1)
	if not c:IsImmuneToEffect(e1) and not c:IsHasEffect(EFFECT_REVERSE_UPDATE) then
		Duel.NegateActivation(ev)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950181,0))
end