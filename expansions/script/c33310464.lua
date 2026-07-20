--织巢之义 忠指护父
local s,id=GetID()

s.VHisc_WEAVENEST=true
s.VHisc_ZHONGZHI=true
local CARD_RYOSHU=33310451
local CARD_LEVATIN=33310490 

function s.initial_effect(c)
	--连接召唤手续
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,99,s.lcheck)
	--①：不受对方场上攻击力最高的怪兽效果影响
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.immval)
	c:RegisterEffect(e1)
	--②：对方攻击力最高的怪兽发动效果时无效并破坏
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_ATKCHANGE+CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.negcon)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
	--②：对方攻击力最高的怪兽攻击自己怪兽时无效攻击并破坏
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_ATKCHANGE+CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.atknegcon)
	e3:SetTarget(s.atknegtg)
	e3:SetOperation(s.atknegop)
	c:RegisterEffect(e3)
	--③：给予「斩烬织巢之刃 良秀」效果
	local ge=Effect.CreateEffect(c)
	ge:SetDescription(aux.Stringid(id,2))
	ge:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ge:SetCode(EVENT_BATTLE_START)
	ge:SetCondition(s.grantedcon)
	ge:SetOperation(s.grantedop)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(s.grantcon)
	e4:SetTarget(s.granttg)
	e4:SetLabelObject(ge)
	c:RegisterEffect(e4)
end

--连接素材
function s.matfilter(c)
	return c.VHisc_WEAVENEST or c.VHisc_ZHONGZHI
end

function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(s.matfilter,1,nil)
end

--判断对方场上攻击力最高的怪兽
function s.highfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()>atk
end

function s.ishighest(c,tp)
	return c:IsFaceup() and c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE) and not Duel.IsExistingMatchingCard(s.highfilter,tp,0,LOCATION_MZONE,1,c,c:GetAttack())
end

--①
function s.immval(e,re)
	local tp=e:GetHandlerPlayer()
	local rc=re:GetOwner()
	return re:IsActiveType(TYPE_MONSTER) and s.ishighest(rc,tp)
end

--②：怪兽效果发动时
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and s.ishighest(re:GetHandler(),tp)
end

function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsChainNegatable(ev) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,re:GetHandler(),1,0,0)
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev)==0 then return end
	if not rc:IsRelateToEffect(re) or Duel.Destroy(rc,REASON_EFFECT)==0 then return end
	s.updateop(e,tp)
end

--②：攻击宣言时
function s.atknegcon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	local tc=Duel.GetAttackTarget()
	return ac and tc and ac:IsControler(1-tp) and tc:IsControler(tp) and s.ishighest(ac,tp)
end

function s.atknegtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,Duel.GetAttacker(),1,0,0)
end

function s.atknegop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	if not ac or not ac:IsRelateToBattle() or not Duel.NegateAttack() then return end
	if Duel.Destroy(ac,REASON_EFFECT)==0 then return end
	s.updateop(e,tp)
end

--攻击力上升及装备处理
function s.eqfilter(c)
	return c:IsCode(CARD_LEVATIN) and not c:IsForbidden()
end

function s.updateop(e,tp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	local atk=c:GetAttack()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(400)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	if atk>=2700 or c:GetAttack()<2700 then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if not Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.eqfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(id,3)) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.eqfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Equip(tp,tc,c,true)
	end
end

--③
function s.grantcon(e)
	return e:GetHandler():IsReason(REASON_DESTROY)
end

function s.gravefilter(c)
	return c:IsCode(id) and c:IsReason(REASON_DESTROY) and not c:IsDisabled()
end

function s.granttg(e,c)
	if not c:IsFaceup() or not c:IsCode(CARD_RYOSHU) then return false end
	local h=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.gravefilter,h:GetControler(),LOCATION_GRAVE,0,nil)
	local tc=g:GetFirst()
	while tc do
		if tc~=h and tc:GetFieldID()<h:GetFieldID() then return false end
		tc=g:GetNext()
	end
	c:RegisterFlagEffect(33310451,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
	return true
end

function s.grantedcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==Duel.GetAttacker() or c==Duel.GetAttackTarget()
end

function s.grantedop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e2:SetTargetRange(1,0)
	e2:SetValue(HALF_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e2,tp)
end