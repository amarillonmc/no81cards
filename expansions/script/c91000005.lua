--两面宿傩
local m=91000005
local cm=c91000005
function c91000005.initial_effect(c)
	c:EnableReviveLimit()  
	aux.AddFusionProcFunRep2(c,cm.fit0,1,99,false)  
	
	--aux.AddFusionProcFunFunRep()
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetValue(SUMMON_TYPE_FUSION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.sumcon)
	e1:SetOperation(cm.sucop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCondition(cm.con3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.operation)
	c:RegisterEffect(e4)
	 local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,3))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,m*2)
	e5:SetHintTiming(0,TIMING_DRAW_PHASE)
	e5:SetTarget(cm.attg)
	e5:SetOperation(cm.atop)
	c:RegisterEffect(e5)
end
function cm.fit0(c) 
	return  c:IsType(TYPE_MONSTER) 
end
function cm.fit1(c) 
	return  c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function cm.sumcon(e,c)
if c==nil then return true end  
	return  Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.fit1,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil)
end
function cm.sucop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,cm.fit1,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,99,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
--e2 1
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	e:SetLabelObject(tc)
	return tc and tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_BATTLE) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local tc=e:GetLabelObject()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,LOCATION_GRAVE)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
--e2 2
function cm.fit2(c,e,tp)
	return c:GetReason()&REASON_EFFECT~=0 and c:GetReasonEffect():GetHandler()==e:GetHandler() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return  eg:IsExists(cm.fit2,1,nil,e,tp)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,nil,0,LOCATION_GRAVE)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectMatchingCard(tp,cm.fit2,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,n,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)	
end
-- e4
function cm.filter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)   
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil) end   
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,nil)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do  
		Duel.Recover(tp,tc:GetBaseAttack(),REASON_EFFECT)
	tc=g:GetNext()
	end 
end
-- e5
function cm.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(e:GetLabel())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
