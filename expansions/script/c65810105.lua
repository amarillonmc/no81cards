--盛夏回忆·蚂蚁
function c65810105.initial_effect(c)
	--特招
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65810105+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65810105.spcon)
	e1:SetTarget(c65810105.sptg)
	e1:SetOperation(c65810105.spop)
	c:RegisterEffect(e1)
	--攻宣无效
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(c65810105.condition3)
	e3:SetCost(c65810105.cost3)
	e3:SetOperation(c65810105.activate3)
	c:RegisterEffect(e3)
	--送墓效果
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetTarget(c65810105.target4)
	e4:SetOperation(c65810105.activate4)
	c:RegisterEffect(e4)
	--除外效果
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_REMOVE)
	e4:SetTarget(c65810105.target4)
	e4:SetOperation(c65810105.activate4)
	c:RegisterEffect(e4)
end



function c65810105.filter(c)
	return c:IsRace(RACE_INSECT) and Duel.GetMZoneCount(tp,c,tp)>0 and c:IsAbleToRemoveAsCost()
end
function c65810105.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c65810105.filter,c:GetControler(),LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c65810105.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c65810105.filter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil,tp,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=g:SelectUnselect(tc,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c65810105.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_SPSUMMON)
end


function c65810105.condition3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c65810105.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() 
	end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c65810105.activate3(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end


function c65810105.thfilter1(c)
	return (c:IsRace(RACE_INSECT) or c:IsSetCard(0xa31)) and c:IsAbleToDeck() and aux.NecroValleyFilter()
end
function c65810105.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65810105.thfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) 
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c65810105.activate4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c65810105.thfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end



