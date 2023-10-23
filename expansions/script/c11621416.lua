--桃源乡的武者
local m=11621416
local cm=c11621416
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--release
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.rlscon)
	e2:SetTarget(cm.rlstg)
	e2:SetOperation(cm.rlsop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_RELEASE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m+10000)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3) 
	cm[c]=e3	
end
cm.SetCard_THY_PeachblossomCountry=true 
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,TYPES_EFFECT_TRAP_MONSTER,2000,0,3,RACE_ZOMBIE,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.filter(c)
	return c.SetCard_THY_PeachblossomCountry and c:IsType(TYPE_MONSTER)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,TYPES_EFFECT_TRAP_MONSTER,1500,300,3,RACE_ZOMBIE,ATTRIBUTE_LIGHT) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
end

function cm.thfilter(c,tp)
	return c.SetCard_THY_PeachblossomCountry and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and (not c:IsForbidden()) and (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or c:IsType(TYPE_FIELD)) 
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 and Duel.SSet(tp,g)~=0 then
		local rg=Duel.SelectMatchingCard(tp,Card.IsReleasableByEffect,tp,LOCATION_ONFIELD,0,1,1,nil)
		if rg:GetCount()>0 then
			Duel.HintSelection(rg)
			Duel.BreakEffect()
			Duel.Release(rg,REASON_EFFECT)
		end
	end
end
function cm.rlsfilter(c)
	return c.SetCard_THY_PeachblossomCountry and c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function cm.rlscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF and Duel.IsExistingMatchingCard(cm.rlsfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.rlstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasableByEffect,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsReleasableByEffect,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,2,0,0) 
end
function cm.rlsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=Group.FromCards(c)
	if not (c:IsRelateToEffect(e) and c:IsSSetable() and Duel.SSet(tp,cg)>0) then return end
	local g1=Duel.SelectMatchingCard(tp,Card.IsReleasableByEffect,tp,LOCATION_ONFIELD,0,1,1,nil)
	if g1:GetCount()<=0 then return end
	local g2=Duel.SelectMatchingCard(tp,Card.IsReleasableByEffect,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g2:GetCount()>0 then
		Duel.HintSelection(g1)
		Duel.HintSelection(g2)
		g1:Merge(g2)
		Duel.Release(g1,REASON_EFFECT)
	end
end