--平凡的学生  鹿目圆香
function c1000602.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1000602,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,10006021)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c1000602.spcost)
	e1:SetTarget(c1000602.sptg)
	e1:SetOperation(c1000602.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10006022)
	e2:SetCondition(c1000602.con)
	e2:SetCost(c1000602.cost)
	e2:SetTarget(c1000602.tg)
	e2:SetOperation(c1000602.op)
	c:RegisterEffect(e2)
	if not NitoriGlobal then
		NitoriGlobal={}
		NitoriGlobal["Effects"]={}
	end
	NitoriGlobal["Effects"]["c1000602"]=e2
end
function c1000602.costfilter(c)
	return c:IsSetCard(0xc204) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_PENDULUM) and c:IsDiscardable() 
end
function c1000602.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000602.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) 
	  and Duel.GetCustomActivityCount(1000602,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.DiscardHand(tp,c1000602.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c1000602.filter(c,e,tp)
	return c:IsSetCard(0xc204) and not (c:IsType(TYPE_TUNER) and c:IsType(TYPE_PENDULUM)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1000602.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c1000602.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c1000602.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1000602.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c1000602.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(1000602)==0 and e:GetHandler():GetTurnID()~=Duel.GetTurnCount()
end
function c1000602.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.GetCustomActivityCount(1000602,tp,ACTIVITY_SPSUMMON)==0 end
end
function c1000602.tgfilter(c)
	return c:IsSetCard(0xc204) and not (c:IsType(TYPE_TUNER) and c:IsType(TYPE_PENDULUM)) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c1000602.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000602.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	e:GetHandler():RegisterFlagEffect(1000602,RESET_EVENT+0x1680000,EFFECT_FLAG_COPY_INHERIT,1)
end
function c1000602.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c1000602.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
