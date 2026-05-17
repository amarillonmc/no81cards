--ワーム・ゼロ
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(s.xyzcon)
	e0:SetOperation(s.xyzop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--adjust
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetCode(EVENT_ADJUST)
	e01:SetRange(LOCATION_EXTRA)
	e01:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	e01:SetOperation(s.adjustop)
	c:RegisterEffect(e01)
	--atk
	--[[local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_UPDATE_ATTACK)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetValue(s.atkval3)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_UPDATE_DEFENSE)
	e10:SetValue(s.defval3)
	c:RegisterEffect(e10)]]
	--immune
	--[[local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_IMMUNE_EFFECT)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetValue(s.efilter)
	c:RegisterEffect(e11)
	--direct attack
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e12)]]
end
function s.mfilter(c)
	return c:IsXyzType(TYPE_MONSTER) and c:IsSetCard(0x3e)
end
function s.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local minc=11
	local maxc=64
	if min then
		minc=math.max(minc,min)
		maxc=max
	end
	local ct=math.max(minc-1,-ft)
	local mg=nil
	mg=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,c)
	return maxc>=11 and mg:IsExists(s.mfilter,11,nil,mg)
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=nil
	if og and not min then
		g=og
	else
		local mg=nil
		if og then
			mg=og:Filter(s.mfilter,nil,c)
		else
			mg=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,c)
		end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local minc=11
		local maxc=64
		if min then
			minc=math.max(minc,min)
			maxc=max
		end
		local ct=math.max(minc-1,-ft)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=mg:FilterSelect(tp,s.mfilter,11,11,nil,mg,ct)
	end
	local sg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		sg:Merge(tc:GetOverlayGroup())
		tc=g:GetNext()
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	--[[if not s.globle_check then
		s.globle_check]]
		local c=e:GetHandler()
		--local token=Duel.CreateToken(tp,id)
		--Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
		--Debug.Message(c:CheckUniqueOnField(tp))
		Duel.ConfirmCards(0,c)
		Duel.Hint(HINT_CARD,0,id)
		--spsummon from hand
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_HAND)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetCondition(s.hspcon)
		e1:SetOperation(s.hspop)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e2:SetRange(LOCATION_EXTRA)
		e2:SetTargetRange(LOCATION_HAND,0)
		e2:SetTarget(s.eftg)
		e2:SetLabelObject(e1)
		Duel.RegisterEffect(e2,tp)
		--adjust
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_ADJUST)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
		e3:SetRange(LOCATION_GRAVE)
		e3:SetCondition(s.effcon)
		e3:SetOperation(s.effop)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e4:SetRange(LOCATION_EXTRA)
		e4:SetTargetRange(LOCATION_GRAVE,0)
		e4:SetTarget(s.eftg)
		e4:SetLabelObject(e3)
		Duel.RegisterEffect(e4,tp)
		--atk up
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_UPDATE_ATTACK)
		e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e5:SetRange(LOCATION_EXTRA)
		e5:SetValue(s.atkval)
		e5:SetTarget(s.atktg)
		Duel.RegisterEffect(e5,tp)
		local e6=e5:Clone()
		e6:SetCode(EFFECT_UPDATE_DEFENSE)
		e6:SetValue(s.defval)
		Duel.RegisterEffect(e6,tp)
		--atk down
		local e7=e5:Clone()
		e7:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e7:SetTarget(s.atktg2)
		e7:SetValue(s.atkval2)
		Duel.RegisterEffect(e7,tp)
		local e8=e7:Clone()
		e8:SetCode(EFFECT_UPDATE_DEFENSE)
		e8:SetValue(s.defval2)
		Duel.RegisterEffect(e8,tp)
		--search
		local e13=Effect.CreateEffect(c)
		e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e13:SetCode(EVENT_SUMMON_SUCCESS)
		e13:SetRange(LOCATION_EXTRA)
		e13:SetCondition(s.tgcon)
		e13:SetOperation(s.tgop)
		Duel.RegisterEffect(e13,tp)
		local e14=e13:Clone()
		e14:SetCode(EVENT_FLIP)
		Duel.RegisterEffect(e14,tp)
		--immune
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetCode(EFFECT_IMMUNE_EFFECT)
		e0:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e0:SetTarget(aux.TargetBoolFunction(Card.IsCode,id))
		e0:SetValue(s.efilter)
		Duel.RegisterEffect(e0,tp)
		local e01=e0:Clone()
		e01:SetCode(EFFECT_DIRECT_ATTACK)
		Duel.RegisterEffect(e01,tp)
	--end
	e:Reset()
end
function s.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function s.hspfilter(c,ft,tp,lv)
	local oc=c:GetOverlayCount()
	return oc>=lv and ((ft>0 and not c:IsControler(tp)) or (ft>-1 and c:IsControler(tp)))
end
function s.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return Duel.IsExistingMatchingCard(s.hspfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ft,tp,e:GetHandler():GetLevel())
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectMatchingCard(tp,s.hspfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,ft,tp,e:GetHandler():GetLevel())
	Duel.Release(g,REASON_COST)
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function s.eftg(e,c)
	return c:IsSetCard(0x3e)
end
function s.matfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN) and not c:IsAttack(0)
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetLocation()~=LOCATION_GRAVE then return end
	local g=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetAttack)
		Duel.Overlay(tg:GetFirst(),Group.FromCards(c)) 
	end
end
function s.atktg(e,c)
	return c:IsSetCard(0x3e) and c:IsFaceup()
end
function s.atktg2(e,c)
	return not c:IsSetCard(0x3e) and c:IsFaceup()
end
function s.atkfilter(c)
	return c:IsSetCard(0x3e) and c:GetAttack()>=0
end
function s.atkval(e,c)
	local g=c:GetOverlayGroup():Filter(s.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function s.deffilter(c)
	return c:IsSetCard(0x3e) and c:GetDefense()>=0
end
function s.defval(e,c)
	local g=c:GetOverlayGroup():Filter(s.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function s.atkval2(e,c)
	local g=c:GetOverlayGroup():Filter(s.atkfilter,nil)
	return (-1)*g:GetSum(Card.GetAttack)
end
function s.defval2(e,c)
	local g=c:GetOverlayGroup():Filter(s.deffilter,nil)
	return (-1)*g:GetSum(Card.GetDefense)
end
function s.tunop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g1:GetCount()>0 then
		Duel.ChangePosition(g1,POS_FACEDOWN_DEFENSE)
	end
	if g2:GetCount()>0 then
		Duel.ChangePosition(g2,POS_FACEUP_ATTACK)
	end
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.atkval3(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(s.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function s.defval3(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(s.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=eg:GetFirst()
	return c:IsOnField() and c:IsSetCard(0x3e)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,5) then return false end
	Duel.DiscardDeck(tp,5,REASON_EFFECT)
end

