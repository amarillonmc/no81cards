--逆元构造 红莲
function c79029800.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c79029800.spcon)
	c:RegisterEffect(e1)
	--t g
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,79029800)
	e2:SetCondition(c79029800.tgcon)
	e2:SetTarget(c79029800.settg)
	e2:SetOperation(c79029800.setop)
	c:RegisterEffect(e2)
	--ww
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetCountLimit(1,19029800)
	e3:SetTarget(c79029800.drtg)
	e3:SetOperation(c79029800.drop)
	c:RegisterEffect(e3)
end
function c79029800.xxfilter(c)
	return not c:IsLevel(3) and not c:IsRank(3) and not c:IsLink(3)
end
function c79029800.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
	  not  Duel.IsExistingMatchingCard(c79029800.xxfilter,c:GetControler(),LOCATION_MZONE,0,1,nil) and not Duel.IsExistingMatchingCard(Card.IsFacedown,c:GetControler(),LOCATION_MZONE,0,1,nil) and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)>0
end
function c79029800.filter(c)
	return c:IsSetCard(0xa991) and c:IsSSetable() and not c:IsType(TYPE_FIELD)
end
function c79029800.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c79029800.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029800.filter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c79029800.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=Duel.SelectMatchingCard(tp,c79029800.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		Duel.SSet(tp,tc)
	end
end
function c79029800.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,0,0)
end
function c79029800.drop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79029800.splimit)
	Duel.RegisterEffect(e1,tp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c79029800.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xa991) and c:IsLocation(LOCATION_EXTRA) 
end