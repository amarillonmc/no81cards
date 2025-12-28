--幻叙吞噬者 伽拉图斯
local s,id,o=GetID()
function s.initial_effect(c)
	--Xyz Summon
	c:EnableReviveLimit()
	--Immune and Atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.con)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	--Cannot SpSummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(s.con)
	c:RegisterEffect(e3)
	--Attach material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id)
	e4:SetTarget(s.atchtg)
	e4:SetOperation(s.atchop)
	c:RegisterEffect(e4)
	--Detach or punish
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e5:SetCondition(s.effcon)
	e5:SetTarget(s.efftg)
	e5:SetOperation(s.effop)
	c:RegisterEffect(e5)

	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_CUSTOM+65133224)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)

	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ex:SetCode(EVENT_ADJUST)
	ex:SetRange(0xff)
	ex:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	ex:SetOperation(s.backop)
	c:RegisterEffect(ex)
end
function s.con(e)
	return e:GetHandler():GetOverlayCount()>0
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetHandler() and te:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) 
		and te:GetActivateLocation()&LOCATION_ONFIELD~=0 and te:IsActivated()
end
function s.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function s.atchtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsType(TYPE_MONSTER) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,TYPE_MONSTER) 
		and e:GetHandler():IsType(TYPE_XYZ) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,TYPE_MONSTER)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function s.atchop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToChain() and tc:IsRelateToChain() then
		Duel.Overlay(c,tc)
	end
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler()
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	else
		Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
function s.xyzfilter(c,e)
	return not c:IsImmuneToEffect(e) and c:IsCanOverlay() and c:IsType(TYPE_MONSTER) and not c:IsAttack(0)
end
function s.fselect(g,atk)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetAttack,atk)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,c,e)
	local atk=c:GetAttack()
	if g:GetSum(Card.GetAttack)>atk then
		g=g:SelectSubGroup(tp,s.fselect,false,1,g:GetCount(),atk)
	end
	Duel.Overlay(c,g)
end
function s.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetOriginalCode()~=id then return end
	if c:IsLocation(LOCATION_MZONE) then return end
	c:SetEntityCode(65133224)
	if c:IsFacedown() then
		Duel.ConfirmCards(tp,Group.FromCards(c))
		Duel.ConfirmCards(1-tp,Group.FromCards(c))
	end
	c:ReplaceEffect(65133224,0,0)
	Duel.Hint(HINT_CARD,0,65133224)
	if c:IsLocation(LOCATION_HAND) then Duel.ShuffleHand(c:GetControler()) end
	Duel.RaiseEvent(e:GetHandler(),EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
end