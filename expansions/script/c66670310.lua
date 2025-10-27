--苍途之祈
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,66670210,66670215,66670220)
	
	-- 自己的额外卡组没有卡存在的场合才能发动，等级合计直到变成仪式召唤的怪兽的等级以上为止，把自己的手卡·场上的怪兽解放，从自己的手卡·卡组·墓地把1只「苍途」仪式怪兽仪式召唤
	local e1=aux.AddRitualProcGreater2(c,s.thfilter,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,nil,s.mfilter,true)
	e1:SetCondition(s.condition)
	c:RegisterEffect(e1)
	
	-- 「苍途之澜影 由花·赛欧」「苍途之双锋 由花·赛欧」「苍途之终咏 桑格蕾茵」的其中任意种在自己场上存在的场合才能发动，墓地的这张卡加入手卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

-- 自己的额外卡组没有卡存在的场合才能发动，等级合计直到变成仪式召唤的怪兽的等级以上为止，把自己的手卡·场上的怪兽解放，从自己的手卡·卡组·墓地把1只「苍途」仪式怪兽仪式召唤
function s.thfilter(c)
	return c:IsSetCard(0x666d)
end

function s.mfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x666d)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end

-- 「苍途之澜影 由花·赛欧」「苍途之双锋 由花·赛欧」「苍途之终咏 桑格蕾茵」的其中任意种在自己场上存在的场合才能发动，墓地的这张卡加入手卡
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(66670210,66670215,66670220)
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
