--罗德岛·术士干员-夜魔
function c79029093.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029093,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c79029093.sprcon)
	e2:SetOperation(c79029093.sprop)
	c:RegisterEffect(e2) 
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029093,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c79029093.sprcon1)
	e2:SetOperation(c79029093.sprop1)
	c:RegisterEffect(e2) 
	--copy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2311603,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c79029093.copycost)
	e3:SetTarget(c79029093.copytg)
	e3:SetOperation(c79029093.copyop)
	c:RegisterEffect(e3) 
	--skip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2311603,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c79029093.copycost1)
	e3:SetTarget(c79029093.copytg)
	e3:SetOperation(c79029093.copyop)
	c:RegisterEffect(e3) 
	--control
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80117527,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,79029093)
	e4:SetTarget(c79029093.target2)
	e4:SetOperation(c79029093.operation2)
	c:RegisterEffect(e4) 
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(51858306,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,79029093333333333333333+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(c79029093.target)
	e1:SetOperation(c79029093.operation)
	c:RegisterEffect(e1)
end
function c79029093.sprfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c79029093.sprfilter1(c,tp,g,sc)
	local lv=c:GetLevel()
	return c:IsType(TYPE_TUNER) and g:IsExists(c79029093.sprfilter2,1,c,tp,c,sc,lv)
end
function c79029093.sprfilter2(c,tp,mc,sc,lv)
	local sg=Group.FromCards(c,mc)
	return c:IsLevel(lv+6) and not c:IsType(TYPE_TUNER)
		and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function c79029093.sprfilter3(c,tp,g,sc)
	local lv=c:GetLevel()
	return not c:IsType(TYPE_TUNER) and g:IsExists(c79029093.sprfilter4,1,c,tp,c,sc,lv)
end
function c79029093.sprfilter4(c,tp,mc,sc,lv)
	local sg=Group.FromCards(c,mc)
	return c:IsLevel(lv+6) and c:IsType(TYPE_TUNER)
		and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function c79029093.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c79029093.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(c79029093.sprfilter1,1,nil,tp,g,c)
end
function c79029093.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c79029093.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,c79029093.sprfilter1,1,1,nil,tp,g,c)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,c79029093.sprfilter2,1,1,mc,tp,mc,c,mc:GetLevel())
	g1:Merge(g2)
	if Duel.SendtoGrave(g1,REASON_COST)~=0 then
	Duel.Recover(tp,Duel.GetLP(1-tp),REASON_EFFECT)
end
end
function c79029093.sprcon1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c79029093.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(c79029093.sprfilter3,1,nil,tp,g,c)
end
function c79029093.sprop1(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c79029093.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,c79029093.sprfilter3,1,1,nil,tp,g,c)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,c79029093.sprfilter4,1,1,mc,tp,mc,c,mc:GetLevel())
	g1:Merge(g2)
	if Duel.SendtoGrave(g1,REASON_COST)~=0 then
	Duel.Recover(tp,Duel.GetLP(1-tp),REASON_EFFECT)
end
end
function c79029093.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(79029093)==0 and Duel.IsCanRemoveCounter(tp,1,0,0x1099,10,REASON_COST) end
	e:GetHandler():RegisterFlagEffect(79029093,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.RemoveCounter(tp,1,0,0x1099,10,REASON_COST)
end
function c79029093.copycost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(79029093)==0 and Duel.CheckLPCost(tp,6000) end
	e:GetHandler():RegisterFlagEffect(79029093,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.PayLPCost(tp,6000)
end
function c79029093.copyfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c79029093.copytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_SKIP_TURN) end
end
function c79029093.copyop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_M1)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_BP)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function c79029093.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,tp,LOCATION_MZONE)
end
function c79029093.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local x=g:GetCount()
	if g:GetCount()>0 then
	   a=g:RandomSelect(tp,1)
	   Duel.GetControl(a,tp)
end
end
function c79029093.filter(c,e,tp)
	return c:IsCode(79029093)
end
function c79029093.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c79029093.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79029093.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79029093.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
end
end



