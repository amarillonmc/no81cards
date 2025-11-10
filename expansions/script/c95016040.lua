-- 怪兽卡：暗月射手
local s, id = GetID()

function s.initial_effect(c)
	-- 效果①：主要阶段除外卡组暗月怪兽并给予伤害
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.damtg)
	e1:SetOperation(s.damop)
	c:RegisterEffect(e1)
	
	-- 效果②：被除外时检索并可能送墓仪式怪兽
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

-- 定义暗月字段
s.darkmoon_setcode = 0x696c

-- 效果①：目标设定
function s.damfilter(c,tp)
	return c:IsSetCard(s.darkmoon_setcode) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) 
		and not c:IsCode(id) and c:IsAbleToRemove()
end

function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.damfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end

-- 效果①：操作处理
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.damfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g>0 then
		local tc=g:GetFirst()
		local atk=tc:GetAttack()
		if atk<0 then atk=0 end
		
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
	end
end

-- 效果②：目标设定
function s.thfilter(c)
	return c:IsSetCard(s.darkmoon_setcode) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(id)
end

function s.tgfilter(c)
	return c:IsSetCard(s.darkmoon_setcode) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end

function s.rifilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function s.ritualcheck(tp)
	return not Duel.IsExistingMatchingCard(s.rifilter ,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil)
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end

-- 效果②：操作处理
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	-- 从卡组把1只「暗月」怪兽加入手卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g1>0 then
		if Duel.SendtoHand(g1,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g1)
			
			-- 自己墓地没有仪式怪兽的场合，可以从卡组把1只「暗月」仪式怪兽送去墓地
			if s.ritualcheck(tp) then
				local g2=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK,0,nil)
				if #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local sg=g2:Select(tp,1,1,nil)
					if #sg>0 then
						Duel.SendtoGrave(sg,REASON_EFFECT)
					end
				end
			end
		end
	end
end