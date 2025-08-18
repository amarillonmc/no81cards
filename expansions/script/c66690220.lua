--蒸汽朋克·压驱皇
local s,id,o=GetID()
function s.initial_effect(c)

	-- 3星怪兽×2只以上
	aux.AddXyzProcedure(c,nil,3,2,nil,nil,99)
	c:EnableReviveLimit()
	
	-- 让自己场上的怪兽的攻击力上升并让对方场上的怪兽的攻击力下降这张卡的超量素材数量×300
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(s.val1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(s.val2)
	c:RegisterEffect(e2)
	
	-- 自己主要阶段才能发动，自己场上2个超量素材取除，从卡组把2张「蒸汽朋克」卡加入手卡（同名卡最多1张）
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end

-- 让自己场上的怪兽的攻击力上升并让对方场上的怪兽的攻击力下降这张卡的超量素材数量×300
function s.val1(e,c)
	return e:GetHandler():GetOverlayCount()*300
end

function s.val2(e,c)
	return e:GetHandler():GetOverlayCount()*(-300)
end

-- 自己主要阶段才能发动，自己场上2个超量素材取除，从卡组把2张「蒸汽朋克」卡加入手卡（同名卡最多1张）
function s.thfilter(c)
	return c:IsSetCard(0x666b) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,2,REASON_EFFECT)
		and g:GetClassCount(Card.GetCode)>=2 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if Duel.RemoveOverlayCard(tp,1,0,2,2,REASON_EFFECT)~=0
		and g:GetClassCount(Card.GetCode)>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
		if tg:GetCount()>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
