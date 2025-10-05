--蒸汽朋克·齿轮之城
local s,id,o=GetID()
function s.initial_effect(c)

    -- 作为这张卡的发动时的效果处理，可以从自己的卡组·墓地把1只「蒸汽朋克」怪兽加入手卡，那之后，可以从手卡把1只「蒸汽朋克」怪兽特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	-- 只要这张卡在场地区域存在，自己把「蒸汽朋克」怪兽的效果发动的场合，也能不把自己的手卡送去墓地或除外来发动
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(66690330)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	
	-- 这个回合没有送去墓地的这张卡在墓地存在的场合，支付300基本分才能发动，这张卡加入手卡
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(aux.exccon)
	e3:SetCost(s.cost)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end

-- 作为这张卡的发动时的效果处理，可以从自己的卡组·墓地把1只「蒸汽朋克」怪兽加入手卡，那之后，可以从手卡把1只「蒸汽朋克」怪兽特殊召唤
function s.thfilter(c)
	return c:IsSetCard(0x666b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if #g>0 then
		if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			if Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 and sg:GetFirst():IsLocation(LOCATION_HAND) then
				Duel.ConfirmCards(1-tp,sg)
				Duel.BreakEffect()
				local spg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
				if #spg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
					and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local sp=spg:Select(tp,1,1,nil)
					Duel.SpecialSummon(sp,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(0x666b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- 这个回合没有送去墓地的这张卡在墓地存在的场合，支付300基本分才能发动，这张卡加入手卡
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,300) end
	Duel.PayLPCost(tp,300)
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
