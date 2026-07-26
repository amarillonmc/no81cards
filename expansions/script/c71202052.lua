--迷失耀斑 祖拜尔·祖巴伊达姆
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon (normal: 3 Level 8; alt: overlay on 迷失耀斑 Xyz when effect activated)
	aux.AddXyzProcedure(c,nil,8,3,s.ovfilter,aux.Stringid(id,0),1,s.xyzop)
	c:EnableReviveLimit()
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.actfilter)
	--①：这张卡的攻击力·守备力上升自己的除外状态的「迷失耀斑」怪兽的等级·阶级的合计×200
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--②：场上的怪兽的等级全部变成5星
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetValue(5)
	c:RegisterEffect(e3)
	--③：这张卡战斗破坏怪兽的场合，把这张卡1个超量素材取除发动。给与对方那只怪兽的原本攻击力数值的伤害
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCountLimit(1,id+o*2)
	e4:SetCondition(aux.bdgcon)
	e4:SetCost(s.damcost)
	e4:SetTarget(s.bdtg)
	e4:SetOperation(s.bdop)
	c:RegisterEffect(e4)
end
-- custom activity filter: track 迷失耀斑 Xyz effects
function s.actfilter(re,tp,cid)
	return not (re:GetHandler():IsSetCard(0x089d) and re:GetHandler():IsType(TYPE_XYZ))
end
-- overlay filter: must be face-up 迷失耀斑 Xyz
function s.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x089d) and c:IsType(TYPE_XYZ)
end
-- overlay condition: once per turn, only after 迷失耀斑 Xyz activated effect
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0
		and Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)>0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function s.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x089d) and c:IsType(TYPE_MONSTER)
end
function s.atkval(e,c)
	local g=Duel.GetMatchingGroup(s.atkfilter,c:GetControler(),LOCATION_REMOVED,0,nil)
	local sum=0
	local tc=g:GetFirst()
	while tc do
		local lv=tc:GetLevel()
		if lv>0 then
			sum=sum+lv
		end
		tc=g:GetNext()
	end
	return sum*200
end
function s.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.bdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=e:GetHandler():GetBattleTarget():GetBaseAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	if dam>0 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
	end
end
function s.bdop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
