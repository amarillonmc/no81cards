--神道觉醒 待宵姑获鸟
local m=96071012
local set=0xff7
local set=0xff8
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0xef)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetOperation(cm.countop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.ctcon)
	e2:SetTarget(cm.cttg)
	e2:SetOperation(cm.ctop)
	c:RegisterEffect(e2)
	--activate limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(cm.condition)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(cm.chcost)
	e4:SetOperation(cm.chop)
	c:RegisterEffect(e4)
end
cm.card_code_list={96071000}
cm.assault_name=96071010
	--add counter
function cm.countop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		c:AddCounter(0xef,3)
	end
end
	--counter
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xef)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0xef,2)
	end
end
	--activate limit
function cm.condition(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and e:GetHandler():GetCounter(0xef)>0
end
	--atkup
function cm.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xef,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0xef,3,REASON_COST)
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(cm.atkval)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
		Duel.BreakEffect()
		if Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_MZONE,1,nil,TYPE_MONSTER) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			local gn=Group.CreateGroup()
			local g2=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_MZONE,nil,TYPE_MONSTER)  
			while g2:GetCount()>0 do
				local tc2=g2:GetFirst()
				if tc2:IsCanBeBattleTarget(tc) then
					gn:AddCard(tc2)
					g2:RemoveCard(tc2)
				else
					g2:RemoveCard(tc2)
				end
			end
			if gn:GetCount()>0 then
				Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,2))
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
				local g1=gn:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_MONSTER)
				if g1:GetCount()>0 then
					local tc1=g1:GetFirst()
					if tc1:IsLocation(LOCATION_MZONE) and tc:IsLocation(LOCATION_MZONE) then
						if not tc1:IsPosition(POS_FACEUP_ATTACK) then
							Duel.ChangePosition(tc1,POS_FACEUP_ATTACK)
						end
						if not tc:IsPosition(POS_FACEUP_ATTACK) then
							Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
						end
						if tc1:IsLocation(LOCATION_MZONE) and tc:IsLocation(LOCATION_MZONE) then 
							Duel.CalculateDamage(tc,tc1)
					end
				end
			end
		end
	end
end
function cm.atkval(e,c)
	local tp=c:GetControler()
	return math.abs(Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)-Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA))*300
end