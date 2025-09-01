--堕福的回音 月下留声
local s,id,o=GetID()
function s.initial_effect(c)

    -- 幻想魔族6星怪兽×2只以上
    c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ILLUSION),6,2,nil,nil,99)

    -- 只要持有超量素材的这张卡在怪兽区域存在，对方若不支付600基本分，则不能把卡的效果发动
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCondition(s.costcon)
	e1:SetCost(s.costchk)
	e1:SetOperation(s.costop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_FLAG_EFFECT+id)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(s.costcon)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
	
	-- 场上的这张卡被战斗·效果破坏的场合，可以作为代替把这张卡1个超量素材取除
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.reptg)
	c:RegisterEffect(e3)
	
	-- ●光：对方不能把这张卡作为效果的对象
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.xyzcon1)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	
	-- ●暗：这张卡的战斗发生的对自己的战斗伤害由对方代受
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e5:SetCondition(s.xyzcon2)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end

-- 只要持有超量素材的这张卡在怪兽区域存在，对方若不支付600基本分，则不能把卡的效果发动
function s.costcon(e)
	return e:GetHandler():GetOverlayCount()>0
end

function s.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,id)
	return Duel.CheckLPCost(tp,ct*600)
end

function s.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,600)
end

-- 场上的这张卡被战斗·效果破坏的场合，可以作为代替把这张卡1个超量素材取除
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end

-- 这张卡得到这张卡作为超量素材中的怪兽属性的以下效果
function s.xyzcon1(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT)
end

function s.xyzcon2(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DARK)
end
