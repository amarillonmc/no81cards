--织巢之眼 命指护父
local s,id=GetID()

s.VHisc_WEAVENEST=true
s.VHisc_MINGZHI=true
local CARD_RYOSHU=33310451
local COUNTER_AMMO=0x2559

function s.initial_effect(c)
	--连接召唤手续
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,99,s.lcheck)
	--弹药指示物
	c:EnableCounterPermit(COUNTER_AMMO)
	c:SetCounterLimit(COUNTER_AMMO,10)
	--①：连接召唤成功时放置弹药指示物
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.linkcon)
	e1:SetTarget(s.cttg)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	--①：战斗破坏怪兽时放置弹药指示物
	local e2=e1:Clone()
	e2:SetProperty(0)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(s.btdescon)
	c:RegisterEffect(e2)
	--②：取除5个弹药指示物将场上1张卡送墓
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(s.tgcost)
	e3:SetTarget(s.tgtg)
	e3:SetOperation(s.tgop)
	c:RegisterEffect(e3)
	--③：取除任意数量弹药指示物上升攻击力并追加攻击
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetCondition(s.atkcon)
	e4:SetCost(s.atkcost)
	e4:SetOperation(s.atkop)
	c:RegisterEffect(e4)
	--④：给予「斩烬织巢之刃 良秀」守备力上升效果
	local ge1=Effect.CreateEffect(c)
	ge1:SetDescription(aux.Stringid(id,3))
	ge1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_BATTLE_START)
	ge1:SetCondition(s.defcon)
	ge1:SetOperation(s.defop)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCondition(s.grantcon)
	e5:SetTarget(s.granttg)
	e5:SetLabelObject(ge1)
	c:RegisterEffect(e5)
	--④：给予「斩烬织巢之刃 良秀」双倍贯穿伤害效果
	local ge2=Effect.CreateEffect(c)
	ge2:SetDescription(aux.Stringid(id,3))
	ge2:SetType(EFFECT_TYPE_SINGLE)
	ge2:SetCode(EFFECT_PIERCE)
	ge2:SetValue(DOUBLE_DAMAGE)
	local e6=e5:Clone()
	e6:SetLabelObject(ge2)
	c:RegisterEffect(e6)
end

--连接素材
function s.matfilter(c)
	return c.VHisc_WEAVENEST or c.VHisc_MINGZHI
end

function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(s.matfilter,1,nil)
end

--①
function s.linkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function s.btdescon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	return tc and tc:IsStatus(STATUS_BATTLE_DESTROYED)
end

function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=10-c:GetCounter(COUNTER_AMMO)
	if chk==0 then return ct>0 and c:IsCanAddCounter(COUNTER_AMMO,ct) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,c,ct,0,COUNTER_AMMO)
end

function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	local ct=10-c:GetCounter(COUNTER_AMMO)
	if ct>0 then
		c:AddCounter(COUNTER_AMMO,ct)
	end
end

--②
function s.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,COUNTER_AMMO,5,REASON_COST) end
	c:RemoveCounter(tp,COUNTER_AMMO,5,REASON_COST)
end

function s.tgfilter(c)
	return c:IsAbleToGrave()
end

function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and s.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end

function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end

--③
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()~=nil
end

function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetCounter(COUNTER_AMMO)
	local t={}
	for i=1,ct do
		if c:IsCanRemoveCounter(tp,COUNTER_AMMO,i,REASON_COST) then
			t[#t+1]=i
		end
	end
	if chk==0 then return #t>0 end
	local num=Duel.AnnounceNumber(tp,table.unpack(t))
	e:SetLabel(num)
	c:RemoveCounter(tp,COUNTER_AMMO,num,REASON_COST)
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	local num=e:GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(num*200)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e2)
	if num>4 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end

--④
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

function s.defcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==Duel.GetAttacker() or c==Duel.GetAttackTarget()
end

function s.defop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end