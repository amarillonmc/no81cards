-- 剑客的奥义书
local s,id=GetID()
function s.initial_effect(c)
	
	-- 效果1：发动时从卡组检索「剑技」魔法卡
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_EQUIP_LIMIT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(s.eqlimit)
	c:RegisterEffect(e0)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e3:SetTarget(s.target)
	e3:SetOperation(s.activate)
	c:RegisterEffect(e3)  
	-- 效果2：提升攻击力
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1800)
	c:RegisterEffect(e2)
	
	-- 效果3：允许在对方回合发动「剑技」速攻魔法
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(LOCATION_HAND,0)
	e6:SetCondition(s.actcon)
	e6:SetTarget(s.acttg)
	c:RegisterEffect(e6)
	local e4=e6:Clone()
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e4)
end
function s.eqfilter(c)
	return c:IsSetCard(0x96b) -- 基础装备对象条件
end

function s.eqlimit(e,c)
	-- 基础检查：必须是目标字段的怪兽
	if not c:IsSetCard(0x96b) then
		return false
	end
	
	-- 检查装备区是否有其他神兵字段装备
	local eqg=c:GetEquipGroup()
	if eqg:IsExists(Card.IsSetCard,1,e:GetHandler(),0x696b) then
		return false
	end
	
	return true
end
function s.filter1(c)
	return c:IsSetCard(0x96b) and c:IsFaceup() and not c:GetEquipGroup():IsExists(Card.IsSetCard,1,c,0x696b)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
-- 效果1：检索「剑技」魔法卡
function s.thfilter(c)
	return c:IsSetCard(0x960) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
		local gf=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)	  
 		  if #gf>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
 			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	 		 local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	 		 Duel.SendtoHand(g,nil,REASON_EFFECT)
	 		 Duel.ConfirmCards(1-tp,g)		 		   		  		   		 
	   	  end
end
-- 效果3：条件检查（对方回合）
function s.actcon(e)
	return Duel.GetTurnPlayer()==1-e:GetHandlerPlayer()
end

-- 效果3：目标检查（「剑技」速攻魔法）
function s.acttg(e,c)
	return c:IsSetCard(0x960) and c:IsType(TYPE_QUICKPLAY)
end