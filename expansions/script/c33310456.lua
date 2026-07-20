--织巢之痕 幻指缚械者
local s,id=GetID()
s.VHisc_WEAVENEST=true
s.VHisc_HUANZHI=true
local CARD_RYOSHU=33310451
local CARD_FATHER=33310462

function s.initial_effect(c)
	--①：支付200基本分，从手卡特殊召唤，那之后给与对方200伤害
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	--①：自己场上有「织巢之血 幻指护父」存在时，对方回合也能发动
	local e1b=e1:Clone()
	e1b:SetType(EFFECT_TYPE_QUICK_O)
	e1b:SetCode(EVENT_FREE_CHAIN)
	e1b:SetCondition(s.spcon)
	c:RegisterEffect(e1b)

	--②：受到战斗·效果伤害时，攻击力上升或破坏怪兽并回复基本分
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+10000)
	e2:SetCondition(s.atkcon)
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)

	--③：被破坏的这张卡在墓地存在时，赋予「斩烬织巢之刃 良秀」破坏耐性
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(s.grcon)
	e3:SetTarget(s.indtg)
	e3:SetValue(s.indct)
	c:RegisterEffect(e3)

end

--①：对方回合发动条件
function s.fatherfilter(c)
	return c:IsFaceup() and c:IsCode(CARD_FATHER)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
		and Duel.IsExistingMatchingCard(s.fatherfilter,tp,LOCATION_MZONE,0,1,nil)
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,200) end
	Duel.PayLPCost(tp,200)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,200)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,200,REASON_EFFECT)
	end
end

--②：自己或对方受到战斗·效果伤害
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return ev>0 and (r&(REASON_BATTLE+REASON_EFFECT))~=0
end

function s.desfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end

function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsFaceup() end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,c,1,tp,500)
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end

	local can_replace=c:GetAttack()+500>=2000
		and Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_MZONE,1,nil)

	if can_replace and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local tc=Duel.SelectMatchingCard(tp,s.desfilter,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
		if not tc then return end

		local atk=math.max(tc:GetAttack(),0)
		if Duel.Destroy(tc,REASON_EFFECT)>0 and atk>0 then
			Duel.BreakEffect()
			Duel.Recover(tp,atk,REASON_EFFECT)
		end
		return
	end

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end

--③：墓地中只让1张已被破坏的同名卡赋予效果，避免耐性叠加
function s.destroyedfilter(c,fid)
	return c:IsCode(id) and c:IsReason(REASON_DESTROY) and c:GetFieldID()<fid
end

function s.grcon(e)
	local c=e:GetHandler()
	if not c:IsReason(REASON_DESTROY) then return false end
	return not Duel.IsExistingMatchingCard(s.destroyedfilter,c:GetControler(),LOCATION_GRAVE,0,1,c,c:GetFieldID())
end

function s.indtg(e,c)
	return c:IsFaceup() and c:IsCode(CARD_RYOSHU) and s.flag(c)
end
function s.flag(c)
	c:RegisterFlagEffect(33310451,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
	return true
end
function s.indct(e,re,r,rp)
	return (r&(REASON_BATTLE+REASON_EFFECT))~=0
end