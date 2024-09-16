--盛夏回忆·隐翅虫
function c65810100.initial_effect(c)
	c:SetSPSummonOnce(65810100)
	aux.AddLinkProcedure(c,c65810100.mat,1,1)
	c:EnableReviveLimit()
	--自诉
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(c65810100.condition)
	e1:SetOperation(c65810100.lsop)
	c:RegisterEffect(e1)
	--连接效果
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,65810100)
	e2:SetCondition(c65810100.condition)
	e2:SetTarget(c65810100.target1)
	e2:SetOperation(c65810100.activate1)
	c:RegisterEffect(e2)
	--攻宣无效
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(c65810100.condition3)
	e3:SetCost(c65810100.cost3)
	e3:SetOperation(c65810100.activate3)
	c:RegisterEffect(e3)
end



function c65810100.mat(c)
	return c:IsLinkRace(RACE_INSECT) and not c:IsLinkType(TYPE_LINK)
end


function c65810100.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c65810100.lsop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65810100.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c65810100.splimit(e,c)
	return not c:IsRace(RACE_INSECT)
end


function c65810100.thfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsAbleToRemove()
end
function c65810100.spfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsAbleToDeck()
end
function c65810100.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c65810100.thfilter,tp,LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c65810100.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(65810100,0),aux.Stringid(65810100,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(65810100,0))
	else op=Duel.SelectOption(tp,aux.Stringid(65810100,1))+1 end
	e:SetLabel(op)
	if op==0 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(65810100,0))
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	else
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(65810100,1))
		e:SetCategory(CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
	end
end
function c65810100.activate1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c65810100.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Remove(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c65810100.spfilter,tp,LOCATION_REMOVED,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end


function c65810100.condition3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c65810100.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() 
	end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c65810100.activate3(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end