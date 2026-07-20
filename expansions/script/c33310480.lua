--神谕终端-双蛇杖
local s,id=GetID()

local CARD_COMMAND_TARGET=33310489
local COUNTER_HERMES=0x2560
s.VHisc_SHIZHI=true

------------------------全局随机数变量设置---------------------
		function VHisc_randomef_set()
			local result=0
			local g=Duel.GetDecktopGroup(1,5)
			local tc=g:GetFirst()
			while tc do
				result=result+tc:GetOriginalCode()
				tc=g:GetNext()
			end
			local g2=Duel.GetDecktopGroup(0,5)
			local tc=g2:GetFirst()
			while tc do
				result=result+tc:GetCode()
				tc=g2:GetNext()
			end
			g:DeleteGroup()
			g2:DeleteGroup()
			return result
		end
--------------------------------------------------

function s.initial_effect(c)
	--装备手续
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_EQUIP)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e0:SetTarget(s.target)
	e0:SetOperation(s.operation)
	c:RegisterEffect(e0)
	--Equip limit
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_EQUIP_LIMIT)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetValue(1)
	c:RegisterEffect(e10)
	--代行-赫尔墨斯指示物
	c:EnableCounterPermit(COUNTER_HERMES)
	--①：对方场上的「指令对象」效果无效
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(s.distg)
	c:RegisterEffect(e1)
	--①：装备怪兽可以向所有「指令对象」各作1次攻击
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(s.atkallval)
	c:RegisterEffect(e2)
	--②：装备怪兽进行战斗时随机适用效果
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_RECOVER+CATEGORY_DRAW+CATEGORY_ATKCHANGE+CATEGORY_DAMAGE+CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.randcon)
	e3:SetTarget(s.randtg)
	e3:SetOperation(s.randop)
	c:RegisterEffect(e3)
	--③：取除9个指示物，使指定怪兽可以攻击9次
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetHintTiming(0,TIMING_BATTLE_PHASE)
	e4:SetCondition(s.multicon)
	e4:SetCost(s.multicost)
	e4:SetTarget(s.multitg)
	e4:SetOperation(s.multiop)
	c:RegisterEffect(e4)

		--random seed
	if not VH_random_seed_check then
		VH_random_seed_check=true

		local VH_random_seed=VHisc_randomef_set()
		
		--设定随机数种子
		function randomef_roll(min,max)
			if min==max then return min end
			min=tonumber(min)
			max=tonumber(max)
			VH_random_seed=(VH_random_seed*16807)%2147484647
			if min~=nil then
				if max==nil then
					local random_number=VH_random_seed/2147484647
					return math.floor(random_number*min)+1
				else
					local random_number=VH_random_seed/2147484647
					if random_number<min then
						VH_random_seed=(VH_random_seed*16807)%2147484647
						random_number=VH_random_seed/2147484647
					end
					return math.floor((max-min)*random_number)+min
				end
			end
			return VH_random_seed
		end
	end

end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end

--①
function s.distg(e,c)
	return c:IsFaceup() and c:IsCode(CARD_COMMAND_TARGET)
end

function s.atkallval(e,c)
	return c:IsFaceup() and c:IsCode(CARD_COMMAND_TARGET) and 1 or 0
end

--②
function s.randcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and (ec==Duel.GetAttacker() or ec==Duel.GetAttackTarget())
end

function s.randtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	if chk==0 then return ec~=nil end
	e:SetLabelObject(ec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end

function s.updateatk(c,value,source)
	if not c or not c:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(source)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(value)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end

function s.updatedef(c,value,source)
	if not c or not c:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(source)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetValue(value)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end

function s.gylimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end

function s.thlimit(e,c,tp,re)
	return re~=nil
end

function s.registergylock(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(s.gylimit)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end

function s.registerbanishlock(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end

function s.registersearchlock(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetTargetRange(0,LOCATION_DECK)
	e1:SetTarget(s.thlimit)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end

function s.registerdouble(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetTargetRange(0,1)
	e1:SetValue(DOUBLE_DAMAGE)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end

function s.randop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=e:GetLabelObject()
	local bc=ec and ec:GetBattleTarget()
	local op=randomef_roll(1,9)
	Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(id,op))
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,op))
	if op==1 then
		Duel.Recover(tp,500,REASON_EFFECT)
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif op==2 then
		s.updateatk(bc,-1000,c)
	elseif op==3 then
		s.updateatk(ec,500,c)
	elseif op==4 then
		s.updatedef(bc,-1000,c)
	elseif op==5 then
		Duel.Damage(1-tp,800,REASON_EFFECT)
	elseif op==6 then
		s.updateatk(ec,150,c)
		s.registergylock(c,tp)
	elseif op==7 then
		s.updateatk(ec,150,c)
		s.registerbanishlock(c,tp)
	elseif op==8 then
		s.updateatk(ec,150,c)
		s.registersearchlock(c,tp)
	elseif op==9 then
		s.registerdouble(c,tp)
	end
	if c:IsRelateToEffect(e) and bc and bc:IsFaceup() and bc:IsCode(CARD_COMMAND_TARGET) and c:IsCanAddCounter(COUNTER_HERMES,3) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		c:AddCounter(COUNTER_HERMES,3)
	end
end

--③
function s.multicon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return Duel.IsBattlePhase() and ec and ec:IsFaceup() and ec:IsCode(CARD_SHIZHI)
end

function s.multicost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,COUNTER_HERMES,9,REASON_COST) end
	c:RemoveCounter(tp,COUNTER_HERMES,9,REASON_COST)
end

function s.multitg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	if chk==0 then return ec and ec:IsFaceup() and ec:IsCode(CARD_SHIZHI) end
	e:SetLabelObject(ec)
end

function s.multiop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetLabelObject()
	if not ec or not ec:IsFaceup() or not ec:IsRelateToEffect(e) or not ec:IsCode(CARD_SHIZHI) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,3))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(8)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	ec:RegisterEffect(e1)
end