--蒸汽朋克·律返姬
local s,id,o=GetID()
function s.initial_effect(c)

	-- 念动力族3星怪兽×2
	aux.AddXyzProcedureLevelFree(c,s.mfilter,nil,2,2)
	
	-- 有融合·同调·超量·连接怪兽的其中任意种在作为超量素材中的这张卡不会被对方的效果破坏，对方不能把这张卡作为效果的对象
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.valcon)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.valcon)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	
	-- 把这张卡1个超量素材取除，以自己的场上·墓地1只念动力族怪兽和对方的场上·墓地1张卡为对象才能发动（这张卡超量召唤的回合，这个效果在对方回合也能发动），那些卡回到手卡
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,id)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.cost)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCondition(s.thcon)
	c:RegisterEffect(e4)
end

-- 这张卡超量召唤的场合，可以让自己场上的阶级3怪兽作为3星怪兽来成为素材
function s.mfilter(c,xyzc)
	return c:IsRace(RACE_PSYCHO) and (c:IsXyzLevel(xyzc,3) or c:IsRank(3))
end

-- 有融合·同调·超量·连接怪兽的其中任意种在作为超量素材中的这张卡不会被对方的效果破坏，对方不能把这张卡作为效果的对象
function s.valcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
end

-- 把这张卡1个超量素材取除，以自己的场上·墓地1只念动力族怪兽和对方的场上·墓地1张卡为对象才能发动（这张卡超量召唤的回合，这个效果在对方回合也能发动），那些卡回到手卡
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function s.thcon(e,tp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
		and e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN)
end

function s.cfilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsFaceupEx() and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g1=Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g2=aux.SelectTargetFromFieldFirst(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,g1:GetCount(),0,0)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	tg=tg:Filter(aux.NecroValleyFilter(),nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
