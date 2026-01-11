--反叛的古之咬 英雄史诗奏
function c28355662.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c28355662.excondition)
	e0:SetCost(c28355662.excost)
	e0:SetDescription(aux.Stringid(28355662,2))
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_CONTROL+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCost(c28355662.cost)
	e1:SetTarget(c28355662.target)
	e1:SetOperation(c28355662.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c28355662.descon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c28355662.destg)
	e2:SetOperation(c28355662.desop)
	c:RegisterEffect(e2)
end
function c28355662.excondition(e)
	return Duel.GetLP(e:GetHandlerPlayer())~=3000
end
function c28355662.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetLP(tp,4000)
end
function c28355662.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)<=3000 or Duel.CheckLPCost(tp,2000) end
	if Duel.GetLP(tp)>3000 then Duel.PayLPCost(tp,2000) end
end
function c28355662.spfilter(c,e,tp)
	return c:IsSetCard(0x285) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and (Duel.GetMZoneCount(1-tp,nil,tp,LOCATION_REASON_CONTROL)>0 or Duel.GetFieldCard(tp,LOCATION_MZONE,2) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,0x4))--c:IsAbleToChangeControler() and 
end
function c28355662.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28355662.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end-- and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	--local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	--Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c28355662.efffilter(c)
	return c:IsSetCard(0x285) and c:IsFaceup() and c.effop
end
function c28355662.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c28355662.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	local kc=Duel.GetFieldCard(tp,LOCATION_MZONE,2)--kogane
	local zone=0xff
	if Duel.GetMZoneCount(1-tp,nil,tp,LOCATION_REASON_CONTROL)==0 and not kc then zone=0x4 end
	if not sc or Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP_ATTACK,zone)==0 then return end
	kc=Duel.GetFieldCard(tp,LOCATION_MZONE,2)
	local b1=sc:IsControlerCanBeChanged()
	local b2=kc
	if not (b1 or b2) then return end
	local op=b1 and 0 or 1
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(28355662,0),aux.Stringid(28355662,1)) end
	if op==0 and Duel.GetControl(sc,1-tp)==0 or op==1 and Duel.Destroy(kc,REASON_EFFECT)==0 then return end
	--not pinch
	local g=Duel.GetMatchingGroup(c28355662.efffilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g==0 then return end
	Duel.BreakEffect()
	for tc in aux.Next(g) do
		tc.effop(tc)
	end
end
function c28355662.descon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at and at:IsAttackAbove(Duel.GetLP(tp)) and at:IsRelateToBattle()
end
function c28355662.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c28355662.gcheck(g)
	return g:FilterCount(Card.IsControler,nil,0)<=1 and g:FilterCount(Card.IsControler,nil,1)<=1
end
function c28355662.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=g:SelectSubGroup(tp,c28355662.gcheck,false,1,2)
	Duel.HintSelection(dg)
	Duel.Destroy(dg,REASON_EFFECT)
end
