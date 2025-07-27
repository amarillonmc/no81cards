--超机龙兵魔 双极阎王
local m=21196525
local cm=_G["c"..m]
function cm.initial_effect(c)
	if not cm._ then
		cm._=true
		local e10=Effect.CreateEffect(c)
		e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e10:SetCode(EVENT_ADJUST)
		e10:SetRange(0xff)
		e10:SetCountLimit(1)
		e10:SetOperation(cm.op10)
		c:RegisterEffect(e10)
	end
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA+LOCATION_HAND)
	e0:SetCondition(cm.con0)
	e0:SetTarget(cm.tg0)
	e0:SetOperation(cm.op0)
	c:RegisterEffect(e0)
	cm.special=e0
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_CANNOT_DISABLE+0x200)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(ATTRIBUTE_FIRE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+0x200)
	e3:SetTargetRange(0,1)
	e3:SetTarget(cm.tg3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(m)
	e7:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e7:SetTargetRange(0,LOCATION_EXTRA)
	e7:SetTarget(cm.tg7)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_CHAINING)
	e8:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(cm.con8)
	e8:SetTarget(cm.tg8)
	e8:SetOperation(cm.op8)
	c:RegisterEffect(e8)	
end
function cm.z(e)
	return e:GetCode()==EFFECT_SPSUMMON_PROC and not e:IsHasProperty(EFFECT_FLAG_SPSUM_PARAM)
end
function cm.op10(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,0,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	for tc in aux.Next(g) do
		local tab={tc:GetCardRegistered(cm.z,GETEFFECT_ALL)}
		if #tab>0 then
			for i = 1,#tab do
			local effect = tab[i]
			local con=effect:GetCondition() or aux.TRUE
			effect:SetCondition(function(ne,nc,...)
				if nc==nil then return true end
				local ntp=nc:GetControler()
				return not ne:GetHandler():IsHasEffect(m) and con(ne,nc,...) 
			end)
			local e1=effect:Clone()
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
			e1:SetTargetRange(POS_FACEUP,1)
			e1:SetCondition(function(ne,nc,...)
				if nc==nil then return true end
				local ntp=nc:GetControler()
				local b1=ne:GetHandler():IsType(TYPE_LINK) and Duel.GetLocationCountFromEx(1-ntp)>0
				local b2=not ne:GetHandler():IsType(TYPE_LINK) and Duel.GetLocationCount(1-ntp,4)>0
				return (b1 or b2) and ne:GetHandler():IsHasEffect(m) and con(ne,nc,...)	
			end)
			tc:RegisterEffect(e1,true)
			end
		end
	end
	e:Reset()
end
function cm.q(c)
	return not (c:IsFaceup() and c:IsSetCard(0x6919)) and c:IsAbleToDeckOrExtraAsCost()
end
function cm.con0(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.q,tp,LOCATION_ONFIELD,0,nil)
	return #g>0 and Duel.GetMZoneCount(tp,g)
end
function cm.tg0(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(cm.q,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(3,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,#g,#g,nil)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.q,tp,LOCATION_ONFIELD,0,nil)
	Duel.SendtoDeck(g,nil,2,REASON_SPSUMMON+REASON_MATERIAL)
end
function cm.con(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.q,tp,LOCATION_ONFIELD,0,nil)
	return #g>0 and Duel.GetMZoneCount(tp,g)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(cm.q,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(3,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,#g,#g,nil)
	if Duel.SendtoDeck(sg,nil,2,REASON_SPSUMMON+REASON_MATERIAL)>0 and Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_MZONE,POS_FACEUP,true) then
		return false
	else
		return false
	end	
end
function cm.tg3(e,c)
	local att=e:GetHandler():GetAttribute()
	return c:IsAttribute(att)
end
function cm.tg7(e,c)
	local att=e:GetHandler():GetAttribute()
	return c:IsFacedown() and not c:IsAttribute(att)
end
function cm.con8(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function cm.tg8(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(aux.TRUE,tp,0,2,nil)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,1,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,1)
end
function cm.op8(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,2,nil)
	if #g<=0 then return end
	Duel.ConfirmCards(tp,g)
	Duel.Hint(3,tp,HINTMSG_ATOHAND)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if Duel.SendtoHand(tc,tp,REASON_EFFECT)>0 and tc:IsLocation(2) and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,1,0,1,nil) then
	Duel.BreakEffect()
	Duel.Hint(3,tp,HINTMSG_OPERATECARD)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,1,0,1,1,nil)
	Duel.SendtoHand(sg,1-tp,REASON_EFFECT)
	Duel.ConfirmCards(tp,sg)
	end
end